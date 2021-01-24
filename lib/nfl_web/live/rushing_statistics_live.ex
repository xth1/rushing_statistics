defmodule NflWeb.RushingStatisticsLive do
  use NflWeb, :live_view
  alias Nfl.Repo
  alias Nfl.Player.RushingStatistics
  import Ecto.Query, only: [from: 2]

  def mount(_params, %{}, socket) do
    query =
      from(s in RushingStatistics,
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
        }
      )

    statistics = Repo.all(query)

    {:ok, assign(socket, statistics: statistics, suggestions: [])}
  end

  def handle_event("search", %{"name" => name}, socket) do
    statistics =
      from(s in RushingStatistics,
        where: s.name == ^name,
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
        }
      )
      |> Repo.all()

    {:noreply, assign(socket, suggestions: [], statistics: statistics)}
  end

  def handle_event("suggest", %{"name" => name}, socket) do
    pattern = "#{name}%"

    suggestions =
      from(s in RushingStatistics, where: ilike(s.name, ^pattern), select: %{name: s.name})
      |> Repo.all()

    {:noreply, assign(socket, suggestions: suggestions)}
  end
end
