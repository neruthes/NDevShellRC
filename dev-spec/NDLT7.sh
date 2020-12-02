#!/bin/bash

if [[ `hostname` != NDLT7 ]]; then
    echo "Not NDLT7!"
    exit 1
fi

if [[ -r ~/Downloads ]]; then
    rsync -av ~/Downloads/ ~/DLD/Default/
    rm -r ~/Downloads
fi

rm -r ~/Desktop > /dev/null 2>&1
