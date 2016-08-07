defmodule Flour.Repo.Migrations.AddOpenidToPosts do
  use Ecto.Migration
  def change do
    alter table(:posts) do
      add :openid, :string

    end
  end
end
