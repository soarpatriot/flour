defmodule Flour.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :openid, :string
      add :nickname, :string
      add :sex, :string
      add :province, :string
      add :country, :string
      add :headimgurl, :string

      timestamps()
    end

  end
end
