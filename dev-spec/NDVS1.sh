#!/bin/bash

if [[ "$HOSTNAME" != "NDVS1" ]]; then
    echo "Not NDVS1!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-vps.sh

alias ls="ls --color"