defmodule Flour.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :post_id, :integer

      timestamps()
    end

  end
end
