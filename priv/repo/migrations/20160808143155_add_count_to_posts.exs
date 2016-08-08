defmodule Flour.Repo.Migrations.AddCountToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :flower, :integer

    end


  end
end
