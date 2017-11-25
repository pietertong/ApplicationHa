基于3.2.1 版本，GOlang:1.8
    version = 2017-09-18 09:30:50 +0800 @f8bc4e320e6dd58b09f3f01bd8f1489a7be9f78c @3.2.1
    compile = 2017-10-24 13:39:45 +0000 by go version go1.8.3 linux/amd64

源码中 admin 文件夹提供了一系列脚本以便快速启动、停止各个组件，提高运维效率。

codis-demo 是codis集群名称

启动codis-dashboard
    使用 codis-dashboard-admin.sh 脚本启动 dashboard，并查看 dashboard 日志确认启动是否有异常。
    ./admin/codis-dashboard-admin.sh start
    tail -100 ./log/codis-dashboard.log.2017-04-08
    2017/04/08 15:16:57 fsclient.go:197: [INFO] fsclient - create /codis3/codis-demo/topom OK
    2017/04/08 15:16:57 main.go:140: [WARN] [0xc42025f7a0] dashboard is working ...
    2017/04/08 15:16:57 topom.go:424: [WARN] admin start service on [::]:18080
    快速启动集群元数据存储使用 zookeeper，默认数据路径保存在 0.0.0.0:2181，若启动失败，请检查当前用户是否对该路径拥有读写权限。

启动codis-proxy
    使用 codis-proxy-admin.sh 脚本启动 codis-proxy，并查看 proxy 日志确认启动是否有异常。
        ./admin/codis-proxy-admin.sh start
        tail -100 ./log/codis-proxy.log.2017-04-08
        2017/04/08 15:39:37 proxy.go:293: [WARN] [0xc4200df760] set sentinels = []
        2017/04/08 15:39:37 main.go:320: [WARN] rpc online proxy seems OK
        2017/04/08 15:39:38 main.go:210: [WARN] [0xc4200df760] proxy is working ...

启动codis-server
    使用 codis-server-admin.sh 脚本启动 codis-server，并查看 redis 日志确认启动是否有异常。
    ./admin/codis-server-admin.sh start
    tail -100 /tmp/redis_6379.log 
    5706:M 08 Apr 16:04:11.748 * DB loaded from disk: 0.000 seconds
    5706:M 08 Apr 16:04:11.748 * The server is now ready to accept connections on port 6379
    redis.conf 配置中 pidfile、logfile 默认保存在 /tmp 目录，若启动失败，请检查当前用户是否有该目录的读写权限。

启动codis-fe
    使用 codis-fe-admin.sh 脚本启动 codis-fe，并查看 fe 日志确认启动是否有异常。
    ./admin/codis-fe-admin.sh start
    tail -100 ./log/codis-fe.log.2017-04-08
    2017/04/08 16:12:13 main.go:100: [WARN] set ncpu = 1
    2017/04/08 16:12:13 main.go:103: [WARN] set listen = 0.0.0.0:9090
    2017/04/08 16:12:13 main.go:115: [WARN] set assets = /home/codis/go/src/github.com/CodisLabs/codis/admin/../bin/assets
    2017/04/08 16:12:13 main.go:153: [WARN] set --filesystem = /tmp/codis

启动哨兵机制
    使用 redis-sentinel 脚本启动，并查看 日志确认启动是否有异常。
    ./bin/redis-sentinel ./datas/sentinel/46379/sentinel.conf --sentinel&
    然后在 【Sentinels】节点添加对应的哨兵IP：Port
    例如：127.0.0.1:46379

脚本 codis实现的是批量启动服务
    zoookeeper[docker]
    codis-dashboard-admin[后台进程]
    codis-proxy-admin[后台进程]
    codis-fe-admin.sh[后台进程]
    以上都可以装到一个docker中,作为一个整体服务来运行，docker 共享目录的方式，进行数据的持久化保存，并及时备份处理

#基于Codis测试开发
    
#感谢CODIS团队
