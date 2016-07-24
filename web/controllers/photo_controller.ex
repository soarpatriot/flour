defmodule Flour.PhotoController do
  use Flour.Web, :controller

  alias Flour.Photo

  def index(conn, _params) do
    photos = Repo.all(Photo)
    render(conn, "index.html", photos: photos)
  end

  def new(conn, _params) do
    changeset = Photo.changeset(%Photo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}) do
    # IO.inspect photo_params
    # IO.inspect photo_params["name"]["filename"]
    # %Plug.Upload{content_type: "image/jpg", filename: photo_params["name"], path: "/Users/liuhaibao/test"}
    changeset = Photo.changeset(%Photo{}, photo_params)

    case Repo.insert(changeset) do
      {:ok, _photo} ->
        conn
        |> put_flash(:info, "Photo created successfully.")
        |> redirect(to: photo_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Repo.get!(Photo, id)
    render(conn, "show.html", photo: photo)
  end

  def edit(conn, %{"id" => id}) do
    photo = Repo.get!(Photo, id)
    changeset = Photo.changeset(photo)
    render(conn, "edit.html", photo: photo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}) do
    photo = Repo.get!(Photo, id)
    changeset = Photo.changeset(photo, photo_params)

    case Repo.update(changeset) do
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo updated successfully.")
        |> redirect(to: photo_path(conn, :show, photo))
      {:error, changeset} ->
        render(conn, "edit.html", photo: photo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Repo.get!(Photo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: photo_path(conn, :index))
  end
end
