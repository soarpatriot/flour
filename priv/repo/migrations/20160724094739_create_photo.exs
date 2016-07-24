defmodule Flour.Repo.Migrations.CreatePhoto do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :name, :string

      timestamps()
    end

  end
end
