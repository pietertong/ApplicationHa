#!/usr/bin/env bash

ZOOKEEPER=`docker ps -a|grep zookeeper`
if [ "" != "${ZOOKEEPER}" ];then
    echo -e '\nZookeeper IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' zookeeper
fi
CODIS_DASHBOARD=`docker ps -a|grep Codis-D28080`
if [ "" != "${CODIS_DASHBOARD}" ];then
    echo -e '\nDashboard IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-D28080
fi
CODIS_PROXY=`docker ps -a|grep Codis-P29000`
if [ "" != "${CODIS_PROXY}" ];then
    echo -e '\nProxy IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-P29000
fi

CODIS_REDIS_SERVER_IS=`docker ps -a|grep Codis-S26382`
if [ "" != "${CODIS_REDIS_SERVER_IS}" ];then
    echo -e '\nCodis-S26382 IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-S26382
else
    echo "None"
fi
CODIS_REDIS_SERVER_IS=`docker ps -a|grep Codis-S26381`
if [ "" != "${CODIS_REDIS_SERVER_IS}" ];then
    echo -e '\nCodis-S26381 IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-S26381
else
    echo "None"
fi
CODIS_REDIS_SERVER_IS=`docker ps -a|grep Codis-S26380`
if [ "" != "${CODIS_REDIS_SERVER_IS}" ];then
    echo -e '\nCodis-S26380 IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-S26380
else
    echo "None"
fi

CODIS_REDIS_SERVER_IS=`docker ps -a|grep Codis-S26379`
if [ "" != "${CODIS_REDIS_SERVER_IS}" ];then
    echo -e '\nCodis-S26379 IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-S26379
else
    echo "None"
fi

CODIS_FE_SERVER_IS=`docker ps -a|grep Codis-F8190`
if [ "" != "${CODIS_FE_SERVER_IS}" ];then
    echo -e '\nCodis-F8190 IP:'
    docker inspect --format='{{.NetworkSettings.IPAddress}}' Codis-F8190
else
    echo "None"
fi