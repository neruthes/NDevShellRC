#!/bin/bash

if [[ `hostname` != NDPS1 ]]; then
    echo "Not NDPS1!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/components/{cli,git,PATH,pbcopy}.sh
