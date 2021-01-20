# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nfl.Repo.insert!(%Nfl.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Nfl.Repo
alias Nfl.Player.RushingStatistics
alias Nfl.Utils
import Jason

json_file = "#{__DIR__}/data/rushing.json"


with {:ok, body} <- File.read(json_file),
     {:ok, rushing_statistics} <- Jason.decode(body) do
  # insert to db
  for rs <- rushing_statistics do
    Repo.insert! %RushingStatistics{
      att: Utils.to_float(rs["Att"]),
      att_g: Utils.to_float(rs["Att/G"]),
      avg: Utils.to_float(rs[" Avg"]),
      first_down: Utils.to_float(rs["1st"]),
      first_down_pct: Utils.to_float(rs["1st%"]),
      forty_plus_yds: Utils.to_float(rs["40+"]),
      fum: Utils.to_float(rs["FUM"]),
      lng: Utils.to_string(rs["Lng"]),
      name: rs["Player"],
      position: rs["Pos"],
      td: Utils.to_float(rs["TD"]),
      team: rs["Team"],
      twenty_plus_yds: Utils.to_float(rs["20+"]),
      yds: Utils.to_float(rs["Yds"]),
      yds_g: Utils.to_float(rs["Yds/G"])
    }
  end
else
  err ->
      IO.inspect(err)
end
