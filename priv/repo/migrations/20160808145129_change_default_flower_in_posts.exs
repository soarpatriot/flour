defmodule Flour.Repo.Migrations.ChangeDefaultFlowerInPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :flower, :integer, default: 0
    end
  end
end
