@hadoop_exec_path fs -mkdir /user/@user/
@hadoop_exec_path fs -chown @user /user/@user/
@hadoop_exec_path fs -chgrp @user /user/@user/
@hadoop_exec_path fs -ls /user | grep @user
@hadoop_exec_path fs -mkdir /data/mapred/staging/@user/
@hadoop_exec_path fs -chown @user /data/mapred/staging/@user/
@hadoop_exec_path fs -chgrp @user /data/mapred/staging/@user/
@hadoop_exec_path fs -ls /data/mapred/staging/ | grep @user
