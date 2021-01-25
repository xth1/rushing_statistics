defmodule NflWeb.RushingStatisticsLive do
  use NflWeb, :live_view
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
  def mount(_params, %{}, socket) do
    statistics = search_players(RushingStatistics, @default_order_by_rule_key)

    {:ok,
     assign(socket,
       statistics: statistics,
       suggestions: [],
       query: "",
       order_by: @default_order_by_rule_key
     )}
  end

  def handle_event("search", %{"query" => query, "order_by" => order_by}, socket) do
    query_statement = search_by_name_query(query)

    statistics = search_players(query_statement, order_by)

    {:noreply, assign(socket, suggestions: [], statistics: statistics, query: query)}
  end

  def handle_event("change", form_data, %{assigns: assigns} = socket) do
    new_assigns =
      Map.merge(
        get_suggestions_assigns(assigns, form_data),
        get_statistics_assigns(assigns, form_data)
      )

    {:noreply,
     assign(
       socket,
       new_assigns
     )}
  end

  defp get_suggestions_assigns(
         %{query: state_query, suggestions: suggestions} = assigns,
         %{"query" => query} = _form_data
       ) do

    if query != state_query do
      suggestions =
        from(s in search_by_name_query(query), select: %{name: s.name})
        |> Repo.all()

      %{suggestions: suggestions}
    else
      %{}
    end
  end

  defp get_statistics_assigns(
         %{order_by: state_order_by, query: state_query} = assigns,
         %{"order_by" => order_by} = _form_data
       ) do
    if order_by != state_order_by do
      query_statement = search_by_name_query(state_query)

      %{
        statistics: search_players(query_statement, order_by),
        order_by: order_by
      }
    else
      %{}
    end
  end

  defp search_by_name_query(name_query) do
    pattern = "#{name_query}%"
    if name_query == "",
      do: RushingStatistics,
      else: from(s in RushingStatistics, where: ilike(s.name, ^pattern))
  end

  defp search_players(query, order_by_field) do
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

    query |> Repo.all()
  end
end
