require 'capistrano/ext/multistage'
#set :gateway, "gateway_user@gateway_server.com"
set :application, "mobilize-server"
set :repository,  "."
set :user, 'deploy'

set :keep_releases, 5
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_cache, true
set :copy_exclude, [".git", ".svn", ".DS_Store", "build"]
set :copy_compression, :gzip
set :git_enable_submodules, true

set :scm, :git

after "deploy:restart", "deploy:cleanup"

set :stages, ["staging","production"]
set :default_stage, "staging"
