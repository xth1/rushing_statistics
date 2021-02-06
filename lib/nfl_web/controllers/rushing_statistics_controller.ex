defmodule NflWeb.RushingStatisticsController do
  use NflWeb, :controller
  alias Nfl.Player.RushingStatisticsHelper

  def export_csv(conn, %{"query" => query, "order_by" => order_by} = _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"rushing_statistics.csv\"")
    |> send_resp(200, generate_csv(query, order_by))
  end

  def team_statistics(conn, _) do
    render(conn, "team_statistics.html", statistics: RushingStatisticsHelper.yds_per_team()) # , error: 
  end

  defp generate_csv(query, order_by) do
    {statistics, _} = RushingStatisticsHelper.by_name_prefix(query, order_by, nil)

    header = [
      "Player",
      "Team",
      "Att/G",
      "Att",
      "Yds",
      "Avg",
      "Yds/G",
      "TD",
      "Lng",
      "1st",
      "1st%",
      "20+",
      "40+",
      "FUM"
    ]

    rows =
      for st <- statistics do
        [
          st[:name],
          st[:team],
          st[:att_g],
          st[:att],
          st[:yds],
          st[:avg],
          st[:yds_g],
          st[:td],
          st[:lng],
          st[:first_down],
          st[:first_down_pct],
          st[:twenty_plus_yds],
          st[:forty_plus_yds],
          st[:fum]
        ]
      end

    Enum.concat([header], rows)
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end
end
