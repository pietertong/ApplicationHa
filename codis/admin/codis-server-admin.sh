#!/usr/bin/env bash

CODIS_ADMIN="${BASH_SOURCE-$0}"
CODIS_ADMIN="$(dirname "${CODIS_ADMIN}")"
CODIS_ADMIN_DIR="$(cd "${CODIS_ADMIN}"; pwd)"

CODIS_BIN_DIR=$CODIS_ADMIN_DIR/../bin
CODIS_LOG_DIR=$CODIS_ADMIN_DIR/../log
CODIS_CONF_DIR=$CODIS_ADMIN_DIR/../datas

CODIS_SERVER_BIN=$CODIS_BIN_DIR/codis-server
CODIS_PID_FILE=$CODIS_LOG_DIR

CODIS_SERVER_LOG_FILE=$CODIS_LOG_DIR/redis_x.log
CODIS_DAEMON_FILE=$CODIS_LOG_DIR/codis-server.out

CODIS_CONF_FILE="$CODIS_CONF_DIR/redis"

echo $CODIS_CONF_FILE

if [ ! -d $CODIS_LOG_DIR ]; then
    mkdir -p $CODIS_LOG_DIR
fi


case $1 in
start)
    echo  "starting codis-server ... "
    for ((i=0;i<5;i++)); do
        let PORT="27379 + i"
        if [ -f "$CODIS_PID_FILE/redis_${PORT}.pid" ]; then
            if kill -0 `cat "$CODIS_PID_FILE/redis_${PORT}.pid"` > /dev/null 2>&1; then
                echo already running as process `cat "$CODIS_PID_FILE/redis_${PORT}.pid"`.
                exit 0
            fi
        fi
        nohup "$CODIS_SERVER_BIN" "${CODIS_CONF_FILE}/${PORT}/redis.conf" > "$CODIS_DAEMON_FILE" 2>&1 </dev/null &
    done
    ;;
stop)
    echo "stopping codis-server ... "
    if [ ! -f "$CODIS_PID_FILE" ]
    then
      echo "no codis-server to stop (could not find file $CODIS_PID_FILE)"
    else
      kill -2 $(cat "$CODIS_PID_FILE")
      echo STOPPED
    fi
    exit 0
    ;;
stop-forced)
    echo "stopping codis-server ... "
    if [ ! -f "$CODIS_PID_FILE" ]
    then
      echo "no codis-server to stop (could not find file $CODIS_PID_FILE)"
    else
      kill -9 $(cat "$CODIS_PID_FILE")
      rm "$CODIS_PID_FILE"
      echo STOPPED
    fi
    exit 0
    ;;
restart)
    shift
    "$0" stop
    sleep 1
    "$0" start
    ;;
*)
    echo "Usage: $0 {start|stop|stop-forced|restart}" >&2

esac
