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