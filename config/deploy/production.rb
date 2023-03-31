set :stage, :production
set :rails_env, :production
set :deploy_to, "/deploy/apps/ytb_share"
set :branch, :main
server "103.183.115.67", user: 'www', roles: %w(web app db)