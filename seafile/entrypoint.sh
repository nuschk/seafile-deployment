#!/bin/sh
set -e

DIR=/entrypoint.sh
PROCNAME=tbd

stop_seafile() {
    echo "Received KILL signal, shutting down seafile"
    seafile-server-latest/seafile.sh stop
}

stop_seahub() {
    echo "Received KILL signal, shutting down seahub"
    seafile-server-latest/seahub.sh stop
}


wait_for_seafile() {

    while ! nc -z localhost 8082; do
        echo "Waiting for seafile server to start..."
        sleep 1
    done
}

overlord() {
    while true;
    do
        sleep 1
        if ! pgrep -f "$1" 2>/dev/null 1>&2; then
            echo "Daemon '$1' has exited"
            exit 1;
        fi
        echo "$1 is alive."
    done
}

case "$1" in
    seafile)
        seafile-server-latest/seafile.sh start
        trap stop_seafile QUIT HUP INT KILL TERM
        trap
        overlord "seafile-controller"
        ;;

    seahub)
        wait_for_seafile
        seafile-server-latest/seahub.sh start 8000
        trap stop_seahub QUIT HUP INT KILL TERM
        trap
        overlord "seahub.wsgi:application"
        ;;

    usage)
        echo "seafile|seahub"
        ;;

    *)
        exec "$@"
        ;;
esac
