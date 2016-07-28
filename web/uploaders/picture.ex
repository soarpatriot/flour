defmodule Flour.Picture do
  use Arc.Definition
  use Arc.Ecto.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @versions [:original, :thumb]
  def __storage, do: Arc.Storage.Local
  def storage_dir(_, {file, scope}) do
    "priv/static/uploads/#{scope.id}"
  end 
   
  def custom_url(id, name,  version) do 
    "#{Application.get_env(:arc, :asset_host)}/uploads/#{id}/#{version}-#{name}" 
  end
  # def url(id, version) do 
    # IO.puts "scope  sdf:  #{scope.id}"
    #  "#{Application.get_env(:arc, :asset_host)}/uploads/#{id}/#{version}.jpg" 
  # end
  # def custom_url(scope, name) do
    # "#{Application.get_env(:arc, :asset_host)}/uploads/#{scope.id}#{Path.extname(file.filename)}" 
  # end
  def thumb_url(file) do 
    thumb_file = filename(:thumb, {file, :thumb}) 
    "#{Application.get_env(:arc, :asset_host)}/uploads/#{thumb_file}.png" 
  end 
  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
     # {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
     {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250"}
  end

  # Override the persisted filenames:
  def filename(version, {file,scope} ) do
    "#{version}-#{Path.rootname(file.file_name)}"

    #"#{version}-#{file.file_name}"
    #timestamp = DateTime.utc_now() |> DateTime.to_unix()
    # "#{version}-#{timestamp}"
  end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
