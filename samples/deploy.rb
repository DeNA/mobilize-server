require 'capistrano/ext/multistage'
set :gateway, "#{(ENV['LOGNAME']=='sagar' ? 'smehta' : ENV['LOGNAME'])}@login.milp.ngmoco.com:50001"
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
