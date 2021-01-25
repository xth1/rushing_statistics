defmodule NflWeb.RushingStatisticsLive do
  use NflWeb, :live_view
  alias Nfl.Repo
  alias Nfl.Player.RushingStatistics
  alias Nfl.Player.RushingStatisticsHelper
  import Ecto.Query, only: [from: 2]

  def mount(_params, %{}, socket) do
    {:ok,
     assign(socket,
       statistics: RushingStatisticsHelper.all(),
       suggestions: [],
       query: "",
       order_by: RushingStatisticsHelper.default_order_by()
     )}
  end

  def handle_event("search", %{"query" => query, "order_by" => order_by}, socket) do
    statistics = RushingStatisticsHelper.by_name_prefix(query, order_by)
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
      %{suggestions: RushingStatisticsHelper.name_suggestions(query)}
    else
      %{}
    end
  end

  defp get_statistics_assigns(
         %{order_by: state_order_by, query: state_query} = assigns,
         %{"order_by" => order_by} = _form_data
       ) do
    if order_by != state_order_by do
      %{
        statistics: RushingStatisticsHelper.by_name_prefix(state_query, order_by),
        order_by: order_by
      }
    else
      %{}
    end
  end
end
