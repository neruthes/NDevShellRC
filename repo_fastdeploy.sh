#!/bin/bash

DEFAULT_REMOTE_HOSTS="NDLT6G supermicro nuc5 NDVM1"
REMOTE_HOSTS="$DEFAULT_REMOTE_HOSTS"

if [[ ! -z $1 ]]; then
    REMOTE_HOSTS="$1"
fi

for host in $REMOTE_HOSTS; do
    rsync -av $PWD/ $host:$PWD/
done
