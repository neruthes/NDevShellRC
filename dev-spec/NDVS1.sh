#!/bin/bash

if [[ "$(hostname)" != "NDVS1" ]]; then
    echo "Not NDVS1!"
    exit 1
fi

if [[ ! -r /tmp/NDVS1-extra-initsh.done ]]; then
    # tcprpserver 22081 10.104.22.81 22
    # tcprpserver 8088 10.104.22.2 8088
    # touch /tmp/NDVS1-extra-initsh.done
fi
