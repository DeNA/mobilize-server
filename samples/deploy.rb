require 'whenever/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'
#Uncomment to set a gateway
#set :gateway, gateway@gatewayhost.com"
set :application, "mobilize-server"
set :repository,  "git@github.ngmoco.com:Ngpipes/mobilize-server.git"
set :user, 'mobilize'
set :rvm_ruby_string, 'ruby-1.9.3-p374@mobilize-server' #update with your favorite gemset
set :keep_releases, 5
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_cache, true
set :copy_exclude, [".git", ".svn", ".DS_Store", "build"]
set :copy_compression, :gzip
set :git_enable_submodules, true

require "whenever/capistrano"
set :whenever_command, "bundle exec whenever"

set :scm, :git

after "deploy:restart", "deploy:cleanup"

set :stages, ["staging","production"]

#amend to your desired deploy folder
set :deploy_to, "/path/to/#{application}"

namespace :bundler do
  task :bundle_new_release do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("rm -f #{release_dir} && mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
    run "cd #{release_path} && bundle install --deployment --without test development"
  end
end

namespace :config do
  task :populate_dirs do
    #uploads your config folder so you don't have all your secrets sitting on the repo
    upload("config", "#{current_release}/", :via => :scp, :recursive => true)
    #add log and tmp folders
    log_dir = "#{current_release}/log"
    tmp_dir = "#{current_release}/tmp"
    run "rm -rf #{log_dir} && mkdir -p #{log_dir}"
    run "rm -rf #{tmp_dir} && mkdir -p #{tmp_dir}"
  end
end

namespace :whenever do
  desc "Update crontab"
  task :update_crontab do
    #environment is set as stage
    run "cd #{current_release} && bundle exec whenever --set environment=#{stage} --update-crontab #{application}"
  end
end

namespace :resque do
  desc "Restart resque-web"
  task :restart_resque_web do
    #environment is set as stage
    run "source /usr/local/rvm/environments/ruby-1.9.3-p374@mobilize-server && cd #{current_release} && MOBILIZE_ENV=#{stage} bundle exec rake mobilize_base:resque_web"
  end
end
