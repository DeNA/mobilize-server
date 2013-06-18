#delete user if there
sudo deluser @user 2>/dev/null
#add user back
sudo adduser --force-badname --disabled-password --gecos "" @user
#add user to mobilize production db
(cd @install_dirmobilize-server/current && bundle exec rake mobilize:add_user[@user,production])
#create mobilize folder
sudo mkdir /home/@user/mobilize 2> /dev/null
sudo mkdir /home/@user/.ssh 2> /dev/null
#copy public key from public keys directory
sudo cp @install_dirmobilize-server/current/config/mobilize/user_keys/@user.ssh.pub /home/@user/.ssh/authorized_keys
sudo chown -R @user:@user /home/@user
sudo chmod 0700 -R /home/@user
