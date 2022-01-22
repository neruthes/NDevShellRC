#!/bin/bash

if [[ "$HOSTNAME" != "NDLT6G" ]]; then
    echo "Not NDLT6G!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-desktop.sh
source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-gentoo.sh

if [[ -e $HOME/Pictures ]]; then
    rsync -av $HOME/Pictures/ $HOME/PIC/Default/
    rm -rf $HOME/Pictures
fi

export BROWSER="firefox-bin"