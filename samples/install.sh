#install the aws version of Ubuntu 12.04
#If you want access to your resque-web,
#make sure your security group has ssh, http, https access
sudo useradd <owner_user_name>
sudo mkdir /home/<owner_user_name>
sudo cp -R /home/ubuntu/.ssh /home/<owner_user_name>/.ssh
sudo chown -R <owner_user_name>:<owner_user_name> /home/<owner_user_name>/.ssh
sudo chown <owner_user_name>:<owner_user_name> /home/<owner_user_name>
sudo chsh <owner_user_name> -s /bin/bash
sudo visudo -f /etc/sudoers.d/mobilize-server
#add in this row:
#<owner_user_name> ALL=(ALL) NOPASSWD:ALL

#do these still as ubuntu user
#gets you going under mongolab
sudo apt-get install git python-pip
sudo pip install mongoctl
mongoctl install-mongodb

sudo su <owner_user_name>
#make sure you configure the mongoid.yml with appropriate params
#production:
#  sessions:
#    default:
#      database: mobilize_production
#      persist_in_safe_mode: true
#      hosts:
#        - <mongolab host>:<port>
#      username: <owner_user_name>
#      password: <owner_user_password>
sudo apt-get install redis-server
#rvm as of 2013-03-30
\curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby=1.9.3
source /home/<owner_user_name>/.rvm/scripts/rvm
rvm gemset create mobilize-server
rvm gemset use mobilize-server --default
gem install bundler
#make sure you configure your capfile so that the <owner_user_name> user
#is ready to go and deploy to your <application_dir> directory:

#from LOCAL machine:
cap production deploy:setup
#capistrano makes root the owner by default, to fix:

#from EC2 machine:
sudo chown -R <owner_user_name>:<owner_user_name> /home/<owner_user_name>

#from LOCAL machine:
cap production deploy
#hopefully everything is fantastic
#possibly you need to restart the resque-web, so do
#from EC2 machine:
cd <application_dir> && MOBILIZE_ENV=production bundle exec rake mobilize_base:resque_web
cd <application_dir> && MOBILIZE_ENV=production bundle console
#now you're in the console.
#irb> irb Mobilize
#The crontabs are running but if you're feeling impatient,
#<irb Mobilize>
#  Jobtracker.restart_workers!
#  Jobtracker.start
#</irb Mobilize>
#this will make sure traffic from port 80 is routed to resque-web
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j     REDIRECT --to-ports 8282

