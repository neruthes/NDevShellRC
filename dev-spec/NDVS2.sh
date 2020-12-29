#!/bin/bash

if [[ "$(hostname)" != "NDVS2" ]]; then
    echo "Not NDVS2!"
    exit 1
fi

tcprpserver 22081 10.104.22.81 22
tcprpserver 80 10.104.22.81 80
s5pserver 8080
