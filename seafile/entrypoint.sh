#!/bin/sh
set -e

DIR=/entrypoint.sh
PROCNAME=tbd


# kill_func() {
#     echo "Received KILL signal, shutting down daemon"
#     pgrep "$PROCNAME" | xargs kill
# }

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

        # Monitor daemon
        # PROCNAME="seafile-controller"
        # trap kill_func HUP INT KILL TERM
        overlord "seafile-controller"
        ;;

    seahub)
        seafile-server-latest/seahub.sh start 8000
        overlord "seahub.wsgi:application"
        ;;

    usage)
        echo "seafile|seahub"
        ;;

    *)
        exec "$@"
        ;;
esac
