set :stage, :production
set :server_name, "yuxian.me"

set :branch, "master"
set :log_level, :debug

set :deploy_to, "/data/www/flower"

server fetch(:server_name), user: "soar", roles: %w{web app db}
