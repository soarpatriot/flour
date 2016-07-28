defmodule Flour.Photo do
  use Flour.Web, :model
  use Arc.Ecto.Schema
  alias Flour.Picture

  schema "photos" do
    field :name, :string
    #  field :name, Flour.Picture.Type
    field :upload, :any, virtual: true    
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
    |> put_name
    |> cast_attachments(params, [:upload])
  end
  def change_name(changeset, name) do 
    Ecto.Changeset.change(changeset, name: name)
  end  
  defp put_name(changeset) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{
          upload: %Plug.Upload{content_type: "image/" <> _, filename: name}
        }
      } ->
        put_change(changeset, :name, name)
      _ -> 
      changeset
    end
  end
  def store(%Plug.Upload{} = upload, scope) do
    Picture.store({upload, scope})
  end

  def url(photo, version) do
    # IO.puts "inspect: #{scope.id}"
    # IO.inspect scope
    # Picture.url({photo.name, photo}, version)
    Picture.custom_url(photo.id, photo.name,version)
  end

end
