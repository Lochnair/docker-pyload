#!/bin/sh

function handle_signal {
    PID=$!
    echo "Received signal. PID is ${PID}"
    kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

USER="pyload"
GROUP="pyload"

# Check if group and user ID matches
if [ $(id -u $USER) != $PUID ] || [ $(id -g $GROUP) != $PGID ]; then
    usermod -u $PUID $USER
    groupmod -g $PGID $GROUP
fi

# Make sure permissions on volumes are correct
printf "Fixing permissions on pyload volumes... "
chown -R $USER:$GROUP /config
printf "Done\n"

# Starting Sonarr
printf "Starting Pyload... \n"
su-exec $USER $@ & wait
