#!/bin/bash

if [[ `hostname` != NDPS1 ]]; then
    echo "Not NDPS1!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/components/cli.sh
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh
source $DEV_HOME_DIR/NDevShellRC/components/git.sh
source $DEV_HOME_DIR/NDevShellRC/components/pbcopy.sh
source $DEV_HOME_DIR/NDevShellRC/components/proxy.sh
