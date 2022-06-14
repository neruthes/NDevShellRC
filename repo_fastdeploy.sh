#!/bin/bash

REMOTE_HOSTS="NDLT6G supermicro nuc5"

for host in $REMOTE_HOSTS; do
    rsync -av $PWD/ $host:$PWD/
done
