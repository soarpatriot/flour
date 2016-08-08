defmodule Flour.Comment do
  use Flour.Web, :model

  schema "comments" do
    field :content, :string

    belongs_to :post, Flour.Post 
    belongs_to :user, Flour.User
    timestamps()
  end

  @optional_fields ~w(post_id user_id)
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :post_id])
    |> validate_required([:content, :post_id])
  end
end
