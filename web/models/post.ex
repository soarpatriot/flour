defmodule Flour.Post do
  use Flour.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string
    field :openid, :string
    
    belongs_to :user, Flour.User
    has_many :photos, Flour.Photo
    timestamps()
  end

  @optional_fields ~w(user_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :user_id])
    # |> validate_required([:title, :content])
    # |> validate_length(:title,max: 140)
    # |> validate_length(:content,max: 140)
  end

end
