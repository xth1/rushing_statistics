defmodule NflWeb.RushingStatisticsLive do
  use NflWeb, :live_view
  alias Nfl.Repo
  alias Nfl.Player.RushingStatistics
  import Ecto.Query, only: [from: 2]
  # def render(assigns) do
  #   ~L"""
  #   Current statistics: <%= @statistics[:name] %>
  #   """
  # end
  def mount(_params, %{}, socket) do
    query = from s in RushingStatistics, select: %{name: s.name, avg: s.avg}
    statistics = Repo.all(query)

    IO.inspect statistics, label: "statistics"

    {:ok, assign(socket, :statistics, statistics)}
  end
end
