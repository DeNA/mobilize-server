server "staging.host.com", :app, :web, :db, :primary => true
set :deploy_to, "/path/to/#{application}"

namespace :bundler do
  task :bundle_new_release do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("rm -f #{release_dir} && mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
    run "cd #{release_path} && bundle install --deployment --without test development"
  end
end

namespace :cron do
  desc "Update crontab"
  task :crontab, :roles => :app do
    run "cd #{current_release} && /usr/bin/whenever --update-crontab #{application}"
  end
end

namespace :config do
  task :deploy, :roles=>:app do
    config_dir = "mobilize" #modify this if your config folder is not named "mobilize" in the same folder as the deploy.rb
    config_dir_name = config_dir.split("/").last
    upload(config_dir, "#{shared_path}/#{config_dir_name}", :via => :scp, :recursive => true)
  end
  task :add_symlinks, :roles=>:app do
    run "rm -f #{release_dir} && mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}"
  end
end

namespace :rake do
  task :setup, :roles=>:app do
    run "cd #{release_path} && rake mobilize_base:create_indexes"
  end
end

after "deploy:update_code" do
  bundler.bundle_new_release
  cron.crontab
  rake.add_indexes
  resque.refresh
end

