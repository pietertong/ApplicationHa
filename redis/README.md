1、创建Redis Docker EXPOSE 6379

2、通过运行多个实例，并配置Redis集群，二主多从架构
    -p/P=> hostPort:containerPort
    -v =>  [host-dir]:[container-dir]
3、测试连接情况

    [root@muban01v redis]# redis-cli -p 127.0.0.1 -p 6380
    127.0.0.1:6380> keys *
    (empty list or set)
    127.0.0.1:6380> 
    
    [root@muban01v redis]# redis-cli -p 127.0.0.1 -p 6382
    127.0.0.1:6382> keys *
    (empty list or set)
    127.0.0.1:6382> 
    
    [root@muban01v redis]# redis-cli -p 127.0.0.1 -p 6381
    127.0.0.1:6381> keys *
    (empty list or set)
    127.0.0.1:6381> 
    
    [root@muban01v redis]# redis-cli -p 127.0.0.1 -p 6383
    127.0.0.1:6383> keys *
    (empty list or set)
    127.0.0.1:6383> 
    
    [root@muban01v redis]# redis-cli -p 127.0.0.1 -p 6385
    127.0.0.1:6385> keys *
    (empty list or set)
    127.0.0.1:6385> 

    [root@muban01v redis]# redis-cli -p 127.0.0.1 -p 6387
    127.0.0.1:6387> keys *
    (empty list or set)
    127.0.0.1:6387> 
    
3、PHP hash一致性，制作登录DMEO，查看列表的简单APP

4、REDIS从服务器，选择一个宕机，观察Demo 的session情况

