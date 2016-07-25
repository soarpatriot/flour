defmodule Flour.Post do
  use Flour.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string
    
    has_many :photos, Flour.Photo
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content])
    |> validate_required([:title, :content])
    |> validate_length(:title,max: 140)
    |> validate_length(:content,max: 140)
  end
end
