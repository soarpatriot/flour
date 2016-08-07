defmodule Flour.PostController do
  use Flour.Web, :controller
  require IEx
  require Exredis
  plug :put_layout, "post.html"
  alias Flour.Post
  alias Flour.Photo
  alias Flour.User

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params, "photos" => photo_ids}) do
    openid = get_session(conn, :openid) 
    user =  Repo.get_by(User, openid: openid) 
    changeset = Post.changeset(%Post{openid: openid, user_id: user.id}, post_params)
    #changeset = Post.changeset(%Post{}, post_params)
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

  def show(conn, %{"id" => id, "code"=> code, "state"=> state}) do
    appid = "#{Application.get_env(:flour, :wechat_appid)}"
    secret = "#{Application.get_env(:flour, :wechat_secret)}"
    userinfo_base = "#{Application.get_env(:flour, :wechat_userinfo_url)}"
    access_url = "#{Application.get_env(:flour, :wechat_access_token_url)}?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code"
    IO.puts access_url
    
    #{:ok,client} = Exredis.start_link
    #foo = (client |> Exredis.query ["GET","FOO"] )
    #IO.puts foo
    #if foo == :undefined do 
    #  IO.puts foo
    #end
    #client |> Exredis.stop
     
     
    conn = put_session(conn, :message, "oksdfad")
    message = get_session(conn, :message) 
    IO.puts "message: #{message}"
    access_token = get_session(conn, :access_token) 
    IO.puts "access_token"
    if !access_token do 
      IO.puts "access_token is empty"
			case HTTPoison.get(access_url) do
				{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          result = Poison.Parser.parse!(body)
          IO.inspect result
          conn = put_session(conn, :access_token, result["access_token"])
          conn = put_session(conn, :openid, result["openid"])
				{:ok, %HTTPoison.Response{status_code: 404}} ->
					IO.puts "Not found :("
				{:error, %HTTPoison.Error{reason: reason}} ->
					IO.inspect reason
			end    
       
    end 
    access_token = get_session(conn, :access_token) 
    openid = get_session(conn, :openid) 
    userinfo_url = "#{userinfo_base}?openid=#{openid}&access_token=#{access_token}"
    IO.puts "access_token: #{access_token}"
    IO.puts "openid: #{openid}"
    user =  Repo.get_by(User, openid: openid) 
      
    # IO.puts "user: #{Length(user)}"
    case HTTPoison.get(userinfo_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        result = Poison.Parser.parse!(body)
        IO.inspect result
        changeset = User.changeset(%User{}, %{"openid"=> result["openid"], "nickname"=> result["nickname"], 
            "province"=> result["province"],
             "country"=> result["country"],
             "headimgurl"=> result["headimgurl"]})
      
        if !user do 
          IO.puts "save"
          Repo.insert(changeset)
        else 
          IO.puts "update"
          Repo.update(user,changeset) 
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end    
 
    post = Repo.get!(Post, id) |> Repo.preload(:photos)
    render(conn, "show.html", post: post, layout: {Flour.LayoutView, "app.html"})
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    IO.inspect post_params
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
