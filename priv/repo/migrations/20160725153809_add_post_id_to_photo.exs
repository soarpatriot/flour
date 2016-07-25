defmodule Flour.Repo.Migrations.AddPostIdToPhoto do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :post_id, :bigint

    end


  end
end
