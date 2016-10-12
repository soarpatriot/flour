defmodule Flour.WechatController do
  use Flour.Web, :controller
  require Logger
  def sign(conn, _params) do 
    noncestr = 111
    timestamp = os_timestamp()
    appid = "#{Application.get_env(:flour, :wechat_appid)}"
    secret = "#{Application.get_env(:flour, :wechat_secret)}"
    url = _params[:url] 
    result = access_token(appid, secret) 
    token = result["access_token"]
    tresult =  ticket(token) 
    t  = tresult["ticket"] 
    
    param_arr = [ "jsapi_ticket=#{t}", "noncestr=#{noncestr}", "timestamp=#{timestamp}", "url=#{url}"]
    signature = sign_param(param_arr)
    json conn,
          %{
            appid: appid,
            noncestr: noncestr, 
            timestamp: timestamp,
            signature: signature 
           }
 
  end

  def os_timestamp do
    {megasec, sec, _microsec} = :os.timestamp
    megasec * 1000000 + sec
  end 

  def sign_param param_arr do 
    con_str =Enum.sort(param_arr) |> Enum.join("&")
    :crypto.hash(:sha,con_str)
  end
  def ticket access_token do 
    result = %{}
    ticket_url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi"
    case HTTPoison.get(ticket_url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            result = Poison.Parser.parse!(body)
            # Logger.info inspect(result)
            #result["access_token"])
            #conn = put_session(conn, :openid, result["openid"])
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            Logger.error "Not found :("
          {:error, %HTTPoison.Error{reason: reason}} ->
            Logger.error inspect(reason)
    
    end    
  end
  def access_token(app_id,secret) do 
    access_url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{app_id}&secret=#{secret}"
    result = %{}
    case HTTPoison.get(access_url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            result = Poison.Parser.parse!(body)
            #  Logger.info inspect(result)
            #result["access_token"])
            #conn = put_session(conn, :openid, result["openid"])
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            Logger.error "Not found :("
          {:error, %HTTPoison.Error{reason: reason}} ->
            Logger.error inspect(reason)
    end    
  end

  def current_url(conn) do 
    Flour.Router.Helpers.url(conn) <> conn.request_path
  end

end
