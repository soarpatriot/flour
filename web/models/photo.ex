defmodule Flour.Photo do
  use Flour.Web, :model
  use Arc.Ecto.Schema

  schema "photos" do
    field :name, Flour.Picture.Type

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> cast_attachments(params, [:name])
  end
end
