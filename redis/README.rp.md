安装路径分配
	[root@muban01v redis]# pwd
	/root/devespace/cloudsafe-test/redis
	[root@muban01v redis]# tree 6380/
	6380/
	├── data
	│   ├── appendonly.aof
	│   ├── dump.rdb
	│   ├── nodes-6379.conf
	│   ├── redis_6379.pid
	│   └── redis.log
	└── redis.conf

	1 directory, 6 files
	[root@muban01v redis]# 

配置DOCKER镜像
	[root@muban01v ~]# cat Dockerfile
	#Dockerfile
	FROM docker.io/centos:centos7.2.1511

	MAINTAINER The redisCluster Project
	RUN  yum -y install wget initscripts tar && \
	    yum -y install make gcc c++ && \
	    cd /usr/local/ && \
	    wget http://192.168.136.164/softs/redis-4.0.1.tar.gz && \
	    tar -zxvf redis-4.0.1.tar.gz && \
	    /bin/rm -fr redis-4.0.1.tar.gz && \
	    /usr/bin/ln -sfT /usr/local/redis/src/redis-server /usr/local/bin/redis-server && \
	    /usr/bin/ln -sfT /usr/local/redis/src/redis-cli /usr/local/bin/redis-cli && \
	    chmod a+x /usr/local/bin/redis-server && chmod a+x /usr/local/bin/redis-cli && \
	#    /usr/bin/sed -i 's/port 6379/port 16379/' /usr/local/redis/redis.conf && \
	    yum clean all
	EXPOSE 16379
	CMD [ "redis-server","/usr/local/redis/redis.conf"]

配置DOCKER容器
	[root@muban01v ~]# docker run -itd -p 6380:6379  -v /root/devespace/cloudsafe-test/redis/6380/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6380/data:/usr/local/redis/data --name redis-6380 redis:latest
	[root@muban01v ~]# docker run -itd -p 6381:6379  -v /root/devespace/cloudsafe-test/redis/6381/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6381/data:/usr/local/redis/data --name redis-6381 redis:latest
	[root@muban01v ~]# docker run -itd -p 6382:6379  -v /root/devespace/cloudsafe-test/redis/6382/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6382/data:/usr/local/redis/data --name redis-6382 redis:latest
	[root@muban01v ~]# docker run -itd -p 6383:6379  -v /root/devespace/cloudsafe-test/redis/6383/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6383/data:/usr/local/redis/data --name redis-6383 redis:latest
	[root@muban01v ~]# docker run -itd -p 6384:6379  -v /root/devespace/cloudsafe-test/redis/6384/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6384/data:/usr/local/redis/data --name redis-6384 redis:latest
	[root@muban01v ~]# docker run -itd -p 6385:6379  -v /root/devespace/cloudsafe-test/redis/6385/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6385/data:/usr/local/redis/data --name redis-6385 redis:latest
	[root@muban01v ~]# docker run -itd -p 16379:16379  -v /root/devespace/cloudsafe-test/redis/6386/redis.conf:/usr/local/redis/redis.conf -v /root/devespace/cloudsafe-test/redis/6386/data:/usr/local/redis/data --name redis-6386 redis:latest


安装依赖库文件

	[root@muban01v ~]# yum install gcc gcc-c++ openssl* readline* ncurses* zlib* libxml* libjpeg* libpng* libxslt* libtool*

安装RUBY > 2.2.0
	[root@muban01v ~]# yum install ruby rubygem

	[root@muban01v ~]# wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz
	[root@muban01v ~]# tar -zxvf ruby-2.4.2.tar.gz && cd ruby-2.4.2 && ./configure && make && make install

安装 REDIS与RUBY接口文件

	[root@muban01v ~]# wget https://rubygems.org/downloads/redis-4.0.1.gem

	[root@muban01v ~]# gem install redis-4.0.1.gem

获取DOCKER 

	[root@muban01v ~]#  docker inspect redis-6380 |grep '"IPAddress"'
		"IPAddress": "172.17.0.7",
	[root@muban01v ~]#  docker inspect redis-6381 |grep '"IPAddress"'
		"IPAddress": "172.17.0.2",
	[root@muban01v ~]#  docker inspect redis-6382 |grep '"IPAddress"'
		"IPAddress": "172.17.0.3",
	[root@muban01v ~]#  docker inspect redis-6383 |grep '"IPAddress"'
		"IPAddress": "172.17.0.4",
	[root@muban01v ~]#  docker inspect redis-6384 |grep '"IPAddress"'
		"IPAddress": "172.17.0.5",
	[root@muban01v ~]#  docker inspect redis-6385 |grep '"IPAddress"'
		"IPAddress": "172.17.0.6",
	[root@muban01v ~]#

配置
 
	[root@051d1e61b337 redis]# ./src/redis-trib.rb create --replicas 1 172.17.0.7:6379 \
	> 172.17.0.2:6379 \
	> 172.17.0.3:6379 \
	> 172.17.0.4:6379 \
	> 172.17.0.5:6379 \
	> 172.17.0.6:6379
	>>> Creating cluster
	>>> Performing hash slots allocation on 6 nodes...
	Using 3 masters:
	172.17.0.7:6379
	172.17.0.2:6379
	172.17.0.3:6379
	Adding replica 172.17.0.4:6379 to 172.17.0.7:6379
	Adding replica 172.17.0.5:6379 to 172.17.0.2:6379
	Adding replica 172.17.0.6:6379 to 172.17.0.3:6379
	M: 72b2771ad36db668d2230a3a3190fcdce2e273ba 172.17.0.7:6379
	   slots:0-5460 (5461 slots) master
	M: c653da9ecc09a7a2f0e4ef9d432c4d33a08306e7 172.17.0.2:6379
	   slots:5461-10922 (5462 slots) master
	M: 36fd3ac1f51cd5ea40860c3a898100948fe34966 172.17.0.3:6379
	   slots:10923-16383 (5461 slots) master
	S: 49dfba145251cfaf4a64069630d68a82a57e45f3 172.17.0.4:6379
	   replicates 72b2771ad36db668d2230a3a3190fcdce2e273ba
	S: dd0bfaaebb0a312a41cc2bbcd7aa44f82cade7a4 172.17.0.5:6379
	   replicates c653da9ecc09a7a2f0e4ef9d432c4d33a08306e7
	S: cc1e56910780b3bff6d631891a6ab4d755a9b066 172.17.0.6:6379
	   replicates 36fd3ac1f51cd5ea40860c3a898100948fe34966
	Can I set the above configuration? (type 'yes' to accept): yes
	>>> Nodes configuration updated
	>>> Assign a different config epoch to each node
	>>> Sending CLUSTER MEET messages to join the cluster
	Waiting for the cluster to join...
	>>> Performing Cluster Check (using node 172.17.0.7:6379)
	M: 72b2771ad36db668d2230a3a3190fcdce2e273ba 172.17.0.7:6379
	   slots:0-5460 (5461 slots) master
	   1 additional replica(s)
	S: cc1e56910780b3bff6d631891a6ab4d755a9b066 172.17.0.6:6379
	   slots: (0 slots) slave
	   replicates 36fd3ac1f51cd5ea40860c3a898100948fe34966
	M: 36fd3ac1f51cd5ea40860c3a898100948fe34966 172.17.0.3:6379
	   slots:10923-16383 (5461 slots) master
	   1 additional replica(s)
	S: 49dfba145251cfaf4a64069630d68a82a57e45f3 172.17.0.4:6379
	   slots: (0 slots) slave
	   replicates 72b2771ad36db668d2230a3a3190fcdce2e273ba
	S: dd0bfaaebb0a312a41cc2bbcd7aa44f82cade7a4 172.17.0.5:6379
	   slots: (0 slots) slave
	   replicates c653da9ecc09a7a2f0e4ef9d432c4d33a08306e7
	M: c653da9ecc09a7a2f0e4ef9d432c4d33a08306e7 172.17.0.2:6379
	   slots:5461-10922 (5462 slots) master
	   1 additional replica(s)
	[OK] All nodes agree about slots configuration.
	>>> Check for open slots...
	>>> Check slots coverage...
	[OK] All 16384 slots covered.
	[root@051d1e61b337 redis]#

检查REDIS集群状态
	[root@muban01v ~]# /usr/local/redis/src/redis-cli -p 6383 -c
	127.0.0.1:6383> CLUSTER info
	cluster_state:ok
	cluster_slots_assigned:16384
	cluster_slots_ok:16384
	cluster_slots_pfail:0
	cluster_slots_fail:0
	cluster_known_nodes:6
	cluster_size:3
	cluster_current_epoch:6
	cluster_my_epoch:1
	cluster_stats_messages_ping_sent:1138
	cluster_stats_messages_pong_sent:1155
	cluster_stats_messages_meet_sent:3
	cluster_stats_messages_sent:2296
	cluster_stats_messages_ping_received:1153
	cluster_stats_messages_pong_received:1141
	cluster_stats_messages_meet_received:2
	cluster_stats_messages_received:2296
	127.0.0.1:6383>
