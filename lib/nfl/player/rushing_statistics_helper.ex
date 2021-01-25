defmodule Nfl.Player.RushingStatisticsHelper do
  alias Nfl.Repo
  alias Nfl.Player.RushingStatistics
  import Ecto.Query, only: [from: 2]
  # TODO: sanitize form parameters to avoid SQL injection atacks
  @order_by_rules %{
    "yds" => [desc: :yds],
    "lng" => [desc: :lng],
    "td" => [desc: :td]
  }
  @default_order_by_rule_key "yds"

  def all(order_by \\ @default_order_by_rule_key, page_num \\ nil),
    do: search_players(RushingStatistics, page_num, order_by)

  def by_name_prefix(name_prefix, order_by \\ @default_order_by_rule_key, page_num \\ nil),
    do: search_players(build_search_query_statement(name_prefix), order_by, page_num)

  def name_suggestions(name_prefix) do
    from(s in build_search_query_statement(name_prefix), select: %{name: s.name})
    |> Repo.all()
  end

  def default_order_by(), do: @default_order_by_rule_key

  defp build_search_query_statement(name_prefix) do
    sanitized_str = like_sanitize(name_prefix)
    pattern = "#{sanitized_str}%"

    if name_prefix == "",
      do: RushingStatistics,
      else: from(s in RushingStatistics, where: ilike(s.name, ^pattern))
  end

  defp like_sanitize(query_str) do
    String.replace(query_str, ~r/([\%_])/, "")
  end

  defp search_players(query, order_by_field, page_num \\ nil)

  defp search_players(query, order_by_field, nil) do
    statistics =
      build_search_players_query_statement(query, order_by_field)
      |> Repo.all()
      |> format_search_player_result()

    {statistics, nil}
  end

  defp search_players(query, order_by_field, page_num) do
    page =
      build_search_players_query_statement(query, order_by_field)
      |> Repo.paginate(page: page_num)

    {format_search_player_result(page.entries), page}
  end

  defp build_search_players_query_statement(query, order_by_field) do
    rule =
      if Map.has_key?(@order_by_rules, order_by_field),
        do: Map.get(@order_by_rules, order_by_field),
        else: Map.get(@order_by_rules, @default_order_by_rule_key)

    query =
      from(s in query,
        select: %{
          att: s.att,
          att_g: s.att_g,
          avg: s.avg,
          first_down: s.first_down,
          first_down_pct: s.first_down_pct,
          forty_plus_yds: s.forty_plus_yds,
          fum: s.fum,
          lng: s.lng,
          lng_td: s.lng_td,
          name: s.name,
          position: s.position,
          team: s.team,
          td: s.td,
          twenty_plus_yds: s.twenty_plus_yds,
          yds: s.yds,
          yds_g: s.yds_g
        },
        order_by: ^rule
      )
  end

  defp format_search_player_result(result) do
    for r <- result do
      %{r | lng: format_lng(r[:lng], r[:lng_td])}
    end
  end

  defp format_lng(lng, true = _lng_td), do: "#{conditional_round(lng)}T"

  defp format_lng(lng, false = _lng_td), do: "#{conditional_round(lng)}"

  defp conditional_round(number) when is_float(number) do
    if number - trunc(number) == 0.0 do
      round(number)
    else
      number
    end
  end
end
