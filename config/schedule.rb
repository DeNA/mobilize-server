# Use this file to easily define all of your cron jobs.
#
#
#set :output, "#{path}/log/schedule.log"

# stdout is ignored, and stderror is sent normally for cron to take care of, which
# probably means it is emailed to the user whose crontab whenever writes to
set :output, {:standard => nil}

#prefix with rvm env --path -- <ruby version>@<gemset name>  && cd path && bundle exec rake
job_type :rake, "source /usr/local/rvm/environments/ruby-1.9.3-p327@mobilize-server && cd #{path} && " +
                "MOBILIZE_ENV=:environment bundle exec rake :task --silent :output"

every 10.minutes do
  #make sure workers stay current and available
  rake "mobilize_base:kill_idle_and_stale_workers"
  rake "mobilize_base:prep_workers"
  #make sure Jobtracker is alive
  rake "mobilize_base:restart!"
end

#
# this file uses the whenever gem to generate cron jobs
# Learn more: http://github.com/javan/whenever
