defmodule Nfl.Repo.Migrations.CreatePlayerRushingStatistics do
  use Ecto.Migration

  def up do
    create table("player_rushing_statistics") do
      add :name, :string, size: 128
      add :team, :string, size: 64
      add :position, :string, size: 64
      add :att, :float, default: 0.0
      add :att_g, :float, default: 0.0
      add :yds, :float, default: 0.0
      add :yds_g, :float, defalt: 0.0
      add :avg, :float, default: 0.0
      add :td, :float, default: 0.0
      add :lng, :string, size: 64
      add :first_down, :float, default: 0.0
      add :first_down_pct, :float, default: 0.0
      add :twenty_plus_yds, :float, default: 0.0
      add :forty_plus_yds, :float, default: 0.0
      add :fum, :float, default: 0.0

      timestamps()
    end
    create index("player_rushing_statistics", [:name])
    create index("player_rushing_statistics", [:yds])
    create index("player_rushing_statistics", [:td])
    create index("player_rushing_statistics", [:lng])
  end

  def down do
    drop table("player_rushing_statistics")
  end
end
