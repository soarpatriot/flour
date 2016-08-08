defmodule Flour.PostController do
  use Flour.Web, :controller
  require IEx
  require Exredis
  plug :auth
  plug :put_layout, "post.html"
  alias Flour.Post
  alias Flour.Photo
  alias Flour.User
  
  def flower(conn, _params) do
    code = 1
    user_id = get_session(conn, :user_id) 
    # user_id = 12
    {:ok,client} = Exredis.start_link
    id = _params["id"]
    count_key = "POST_#{id}_COUNT"
    list_key = "POST_#{id}_LIST"

    flowered = client |> Exredis.Api.sismember(list_key, user_id)
    IO.inspect flowered
    if flowered == "0" do 
      IO.puts "add"
      code = 0
      client |> Exredis.Api.incr count_key 
    end
    client |> Exredis.Api.sadd(list_key, user_id)
    if !is_nil(user_id) do 
       my_list_key = "MY_#{user_id}_LIST"
      client |> Exredis.Api.sadd(my_list_key, id)
    end
    
    flower_count = client |> Exredis.Api.get(count_key)
    IO.puts "conunt: #{flower_count}"
    client |> Exredis.stop
    #if foo == :undefined do 
    #  IO.puts foo
    #end
    

    json conn,
          %{ code: code,  
             count: flower_count 
           }
 
    #post = Repo.get!(Post, id) |> Repo.preload(:photos) |> Repo.preload :user
    #render(conn, "show.html", post: post, flower_count: flower_count, layout: {Flour.LayoutView, "app.html"})
    
  end
  def index(conn, _params) do
    user_id = get_session(conn, :user_id) 
    posts = Repo.all(from p in Post, where: p.user_id == ^user_id )
    #  posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params, "photos" => photo_ids}) do
    openid = get_session(conn, :openid) 
    user =  Repo.get_by(User, openid: openid) 
    title = "我爱久久"
    content = "我爱你！"

    changeset = Post.changeset(%Post{openid: openid,user_id: user.id}, post_params)
    if post_params["title"] do 
      changeset = Ecto.Changeset.put_change(changeset, :title, title)
    end 
    if post_params["content"] do 
      changeset = Ecto.Changeset.put_change(changeset, :content, content)
    end 
 
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

  def show(conn, %{"id" => id} = params ) do
    
    {:ok,client} = Exredis.start_link
    count_key = "POST_#{id}_COUNT"
    flower_count = client |> Exredis.Api.get(count_key)
    if flower_count == :undefined do 
      flower_count = 0
    end
    IO.puts "count: #{flower_count}"
    client |> Exredis.stop
     
    post = Repo.get!(Post, id) |> Repo.preload(:photos) |> Repo.preload :user
    render(conn, "show.html", post: post, flower_count: flower_count, layout: {Flour.LayoutView, "app.html"})
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
  
  def auth(conn, _params) do 
    access_token = get_session(conn, :access_token) 
    openid = get_session(conn, :openid)
    code_url = "#{Application.get_env(:flour, :wechat_code_url)}"
    appid = "#{Application.get_env(:flour, :wechat_appid)}"
    secret = "#{Application.get_env(:flour, :wechat_secret)}"
    userinfo_base = "#{Application.get_env(:flour, :wechat_userinfo_url)}"
    current_url = Flour.Router.Helpers.url(conn) <> conn.request_path

    IO.puts "access_token: #{access_token}"
    IO.puts "openid: #{openid}"
    code = conn.params["code"]    

    if is_nil(access_token) or is_nil(openid) do 
      
      IO.puts "access_token or openid is empty"
      if is_nil(code) do 
        code_url = "#{code_url}?appid=#{appid}&redirect_uri=#{current_url}&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect" 
        redirect conn |> halt, external: code_url
        
      else 
        IO.puts "code=#{code}"
        access_url = "#{Application.get_env(:flour, :wechat_access_token_url)}?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code"
        IO.puts access_url
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

        access_token = get_session(conn, :access_token) 
        openid = get_session(conn, :openid)
        userinfo_url = "#{userinfo_base}?openid=#{openid}&access_token=#{access_token}"
        IO.puts "access_token: #{access_token}"
        IO.puts "openid: #{openid}"

        user =  Repo.get_by(User, openid: openid)
            
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
                case Repo.insert(changeset) do 
                  {:ok, _user} ->
                    conn = put_session(conn, :user_id, _user.id) 
                end
              else 
                IO.puts "update"
                conn = put_session(conn, :user_id, user.id) 
                # Repo.update(user,changeset) 
              end
            {:ok, %HTTPoison.Response{status_code: 404}} ->
              IO.puts "Not found :("
            {:error, %HTTPoison.Error{reason: reason}} ->
              IO.inspect reason
        end    
      end            
    end 
    conn 
  end
end
