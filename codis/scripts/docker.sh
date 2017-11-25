#!/bin/bash

hostip=`ifconfig eth0 | grep "inet " | awk -F " " '{print $2}'`

if [ "x$hostip" == "x" ]; then
    echo "cann't resolve host ip address"
    exit 1
fi

mkdir -p log

case "$1" in
zookeeper)
    docker rm -f      "zookeeper" &> /dev/null
    docker run --name "zookeeper" -d \
            --read-only \
            -p 2181:2181 \
            jplock/zookeeper
    ;;

dashboard)
    docker rm -f      "Codis-D28080" &> /dev/null
    docker run --name "Codis-D28080" -d \
        --read-only -v /root/devespace/cloudsafe-test/codis/config/dashboard.toml:/codis/dashboard.toml \
                    -v /root/devespace/cloudsafe-test/codis/log:/codis/log \
                    -v /root/devespace/cloudsafe-test/codis/tmp/codis:/tmp/codis \
        -p 28080:18080 \
        codis-cluster \
        codis-dashboard -l log/dashboard.log -c dashboard.toml
    ;;

proxy)
    docker rm -f      "Codis-P29000" &> /dev/null
    docker run --name "Codis-P29000" -d \
        --read-only -v /root/devespace/cloudsafe-test/codis/config/proxy.toml:/codis/proxy.toml \
                    -v /root/devespace/cloudsafe-test/codis/log:/codis/log \
        -p 29000:19000 -p 21080:11080 \
        codis-cluster \
        codis-proxy -l log/proxy.log -c proxy.toml
    ;;

server)
    for ((i=0;i<4;i++)); do
        let port="26379 + i"
        docker rm -f      "Codis-S${port}" &> /dev/null
        docker run --name "Codis-S${port}" -d \
            -v /root/devespace/cloudsafe-test/codis/log:/codis/log \
            -p $port:6379 \
            codis-cluster \
            codis-server --logfile log/${port}.log
    done
    ;;

fe)
    docker rm -f      "Codis-F8190" &> /dev/null
    docker run --name "Codis-F8190" -d \
         -v /root/devespace/cloudsafe-test/codis/log:/codis/log \
         -v /root/devespace/cloudsafe-test/codis/config/codis.json:/codis/codis.json \
         -p 8080:8080 \
    codis-cluster \
    codis-fe -l log/fe.log --zookeeper 172.17.0.91:2181 --listen=0.0.0.0:8080 --assets=/gopath/src/github.com/CodisLabs/codis/bin/assets
    ;;

cleanup)
    docker rm -f      "Codis-D28080" &> /dev/null
    docker rm -f      "Codis-P29000" &> /dev/null
    for ((i=0;i<4;i++)); do
        let port="26379 + i"
        docker rm -f      "Codis-S${port}" &> /dev/null
    done
    docker rm -f      "Codis-Z2181" &> /dev/null
    ;;

*)
    echo "wrong argument(s)"
    ;;

esac
