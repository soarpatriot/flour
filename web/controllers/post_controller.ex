defmodule Flour.PostController do
  use Flour.Web, :controller
  require IEx
  plug :put_layout, "post.html"
  alias Flour.Post
  alias Flour.Photo

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params, "photos" => photo_ids}) do
    changeset = Post.changeset(%Post{}, post_params)
    ps = String.split(photo_ids, ",")
      |> Enum.map( &(String.to_integer(&1)) )
    # query = from p in Photo, where: p.id in ^ps
    # photos = Repo.all(query)
    case Repo.insert(changeset) do
      {:ok, _post} ->
        from( p in Photo, where: p.id in ^ps)
         |> Repo.update_all(set: [post_id: _post.id])
        conn
         |> put_flash(:info, "Post created successfully.")
         |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        # json conn, changeset
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id) |> Repo.preload(:photos)
    render(conn, "show.html", post: post, layout: {Flour.LayoutView, "app.html"})
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
