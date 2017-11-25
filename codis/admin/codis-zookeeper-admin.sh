#!/usr/bin/env bash
DOCKER_CONTAINER="zookeeper"
DOCKER_IMAGES="jplock/${DOCKER_CONTAINER}"

case $1 in
    start)
        STOP_STATUS=`docker ps -a|grep "${DOCKER_CONTAINER}"`
        if [ "" == "${STOP_STATUS}" ];then
            docker run --name "${DOCKER_CONTAINER}" -d --read-only -p 2181:2181 "${DOCKER_IMAGES}"
        else
            docker restart "${DOCKER_CONTAINER}" &> /dev/null
        fi
        docker ps -a|grep "${DOCKER_CONTAINER}"
    ;;
    foregound)
        echo -e "CAN\'t RUN FOREGROUND."
       ;;
    stop)
        STOP_STATUS=`docker ps -a|grep "${DOCKER_CONTAINER}" |grep 'Up '`
        if [ "" == "${STOP_STATUS}" ];then
            docker stop "${DOCKER_CONTAINER}" &> /dev/null
        else
            echo -e "STOP STATUS..."
            echo -e "CAN\'t STOP ${DOCKER_CONTAINER}."
        fi
       ;;
    kill)
        ALIVE_STATUS=`docker ps -a|grep "${DOCKER_CONTAINER}" |grep Up 'Up '`
        if [ "" != "${ALIVE_STATUS}" ];then
            docker stop  "${DOCKER_CONTAINER}" &> /dev/null
        else
            echo -e "ALRAEDY STOP STATUS"
        fi
       ;;
    restart)
        ALIVE_STATUS=`docker ps -a|grep "${DOCKER_CONTAINER}"`
        if [ "" != "${ALIVE_STATUS}" ];then
            docker restart "${DOCKER_CONTAINER}" &> /dev/null
        fi
       ;;
    cleanup)
        ALIVE_STATUS=`docker ps -a|grep "${DOCKER_CONTAINER}"`
        if [ "" != "${ALIVE_STATUS}" ];then
            docker rm -f  "${DOCKER_CONTAINER}" &> /dev/null
        else
            echo -e "ALRAEDY REMOVED"
        fi
       ;;
    *)
        echo -e "\nUsage: $0 { start | daemon | stop | kill | restart | cleanup }\n" >&2
esac
