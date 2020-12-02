#!/bin/bash

if [[ `hostname` != NDVS2 ]]; then
    echo "Not NDVS2!"
    exit 1
fi

if [[ ! -r /tmp/NDVS2-extra-initsh.done ]]; then
    tcprpserver 22081 10.104.22.81 22
    echo "Proxying 'localhost:22081' -> '10.104.22.81:22'"
    s5pserver 8080
    echo "Created SOCKS5 proxy at 'localhost:8080'"
    touch /tmp/NDVS2-extra-initsh.done
fi
