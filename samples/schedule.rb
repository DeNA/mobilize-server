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

#every 5 minutes

every '0,5,10,15,20,25,30,35,40,45,50,55 * * * *' do
  #make sure workers stay current
  rake "mobilize_base:kill_idle_and_stale_workers"
end

every '1,6,11,16,21,26,31,36,41,46,51,56 * * * *' do
  #make Jobtracker is alive
  rake "mobilize_base:start"
end

every '2,7,12,17,22,27,32,37,42,47,52,57 * * * *' do
  #make sure there are enough workers
  rake "mobilize_base:prep_workers"
end

#every hour

every '2 * * * *' do
  #make sure workers don't go over memory limit
  rake "mobilize_base:kill_idle_workers"
end

every '6 * * * *' do
  #make Jobtracker is fresh and under memory limit
  rake "mobilize_base:restart"
end

#
# this file uses the whenever gem to generate cron jobs
# Learn more: http://github.com/javan/whenever
