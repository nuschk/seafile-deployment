#!/bin/sh
set -e

DIR=/entrypoint.sh
PROCNAME=tbd

start_seafile() {
    echo "Starting seafile and seahub..."
    seafile-server-latest/seafile.sh start
    seafile-server-latest/seahub.sh start 8000
}

stop_seafile() {
    echo "Stopping seafile and seahub..."
    seafile-server-latest/seafile.sh stop
    seafile-server-latest/seahub.sh stop
}

wait_while_alive() {
    while true;
    do
        sleep 1
        if ! pgrep -f "seafile-controller" 2>/dev/null 1>&2; then
            echo "Seafile has exited"
            exit 1;
        fi

        if ! pgrep -f "seahub.wsgi:application" 2>/dev/null 1>&2; then
            echo "Seahub has exited"
            exit 1;
        fi

        echo "Seafile and seahub are still alive."
    done
}

case "$1" in
    seafile)
        seafile-server-latest/seafile.sh start

        echo "bernhard.maeder@gmail.com
123123
123123" | seafile-server-*/reset-admin.sh

        seafile-server-latest/seahub.sh start 8000
        trap stop_seafile QUIT HUP INT KILL TERM
        trap
        wait_while_alive "seafile-controller"
        ;;

    usage)
        echo "entrypoint.sh seafile|<cmd>"
        ;;

    *)
        exec "$@"
        ;;
esac
