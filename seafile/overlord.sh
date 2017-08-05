#!/bin/bash

set -e

kill_func() {

}

trap kill_func KILL

exec "$@"

while true;
do
    if ! pgrep -f "seafile-controller" 2>/dev/null 1>&2; then
        echo "Seafile daemon has exited"
        exit 1;
    fi

done

pgrep name | xargs kill