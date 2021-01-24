defmodule Nfl.Player.RushingStatistics do
  use Ecto.Schema
  alias Nfl.Repo
  import Ecto.Changeset

  schema "player_rushing_statistics" do
    field(:att, :float)
    field(:att_g, :float)
    field(:avg, :float)
    field(:first_down, :float)
    field(:first_down_pct, :float)
    field(:forty_plus_yds, :float)
    field(:fum, :float)
    field(:lng, :string)
    field(:name, :string)
    field(:position, :string)
    field(:td, :float)
    field(:team, :string)
    field(:twenty_plus_yds, :float)
    field(:yds, :float)
    field(:yds_g, :float)

    timestamps()
  end

  @doc false
  def changeset(rushing_statistics, attrs) do
    rushing_statistics
    |> cast(attrs, [
      :name,
      :team,
      :position,
      :att,
      :att_g,
      :yds,
      :yds_g,
      :avg,
      :td,
      :lng,
      :first_down,
      :first_down_pct,
      :twenty_plus_yds,
      :forty_plus_yds,
      :fum
    ])
    |> validate_required([
      :name,
      :team,
      :position,
      :att,
      :att_g,
      :yds,
      :yds_g,
      :avg,
      :td,
      :lng,
      :first_down,
      :first_down_pct,
      :twenty_plus_yds,
      :forty_plus_yds,
      :fum
    ])
  end
end
