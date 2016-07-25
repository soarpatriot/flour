defmodule Flour.Photo do
  use Flour.Web, :model
  use Arc.Ecto.Schema

  schema "photos" do
    field :name, Flour.Picture.Type
    
    belongs_to :post, Flour.Post
    timestamps()
  end

  # @required_fields ~w(description complete)
  @optional_fields ~w(post_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> cast_attachments(params, [:name])
  end
end
