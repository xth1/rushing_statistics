defmodule NflWeb.RushingStatisticsLive do
  use NflWeb, :live_view
  alias Nfl.Player.RushingStatisticsHelper

  def mount(_params, %{}, socket) do
    {statistics, page} =
      RushingStatisticsHelper.all(RushingStatisticsHelper.default_order_by(), 0)

    {:ok,
     assign(socket,
       page: page,
       statistics: statistics,
       suggestions: [],
       query: "",
       order_by: RushingStatisticsHelper.default_order_by()
     )}
  end

  def handle_event("search", %{"query" => query, "order_by" => order_by}, socket) do
    {statistics, page} = RushingStatisticsHelper.by_name_prefix(query, order_by, 0)
    {:noreply, assign(socket, suggestions: [], statistics: statistics, page: page, query: query)}
  end

  def handle_event("clear-search", _, %{assigns: %{order_by: state_order_by}} = socket) do
    query = ""
    {statistics, page} = RushingStatisticsHelper.by_name_prefix(query, state_order_by, 0)
    {:noreply, assign(socket, suggestions: [], statistics: statistics, page: page, query: query)}
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

  def handle_event(
        "change-page",
        %{"page-number" => page_number},
        %{assigns: %{order_by: state_order_by, query: state_query, page: state_page}} = socket
      ) do
    if state_page.page_number != page_number do
      {statistics, page} = RushingStatisticsHelper.by_name_prefix(state_query, state_order_by, page_number)
      {:noreply, assign(socket, statistics: statistics, page: page)}
    else
      {:noreply, socket}
    end
  end

  defp get_suggestions_assigns(
         %{query: state_query} = _assigns,
         %{"query" => query} = _form_data
       ) do
    if query != state_query do
      %{suggestions: RushingStatisticsHelper.name_suggestions(query)}
    else
      %{}
    end
  end

  defp get_statistics_assigns(
         %{order_by: state_order_by, query: state_query} = _assigns,
         %{"order_by" => order_by} = _form_data
       ) do
    if order_by != state_order_by do
      {statistics, page} = RushingStatisticsHelper.by_name_prefix(state_query, order_by, 0)

      %{
        statistics: statistics,
        page: page,
        order_by: order_by
      }
    else
      %{}
    end
  end
end
