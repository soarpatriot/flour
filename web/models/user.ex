defmodule Flour.User do
  use Flour.Web, :model

  schema "users" do
    field :openid, :string
    field :nickname, :string
    field :sex, :string
    field :province, :string
    field :country, :string
    field :headimgurl, :string

    has_many :posts, Flour.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:openid, :nickname, :sex, :province, :country, :headimgurl])
    |> validate_required([:openid, :nickname, :sex, :province, :country, :headimgurl])
  end
end
