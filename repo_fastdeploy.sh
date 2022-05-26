#!/bin/bash

REMOTE_HOSTS="NDLT6G supermicro"

for host in $REMOTE_HOSTS; do
    rsync -av $PWD/ $host:$PWD/
done
