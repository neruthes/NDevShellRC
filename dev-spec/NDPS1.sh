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

tcprpserver 8080 10.104.22.2 8080

function NDPS1-system-mount() {
    isQUIET=$1

    function qecho() {
        if [[ "x$isQUIET" == 'x' ]]; then
            echo $1
        fi
    }

    if [[ -r /home/.mounted ]]; then
        qecho "Already mounted '/home'."
    else
        qecho "Decrypting '/home.luks'..."
        cryptsetup open /home.luks home.luks
        qecho "Mounting '/home.luks' on '/home'..."
        mount /dev/mapper/home.luks /home
    fi

    if [[ -r /mnt/NEPd2/Data/.mounted ]]; then
        qecho "Already mounted 'NEPd2:Data'."
    else
        qecho "Decrypting 'NEPd2:Data'..."
        cryptsetup open /dev/disk/by-partlabel/NEPd2_Data NEPd2_Data -d /home/neruthes/.MyLuksKey
        qecho "Mounting 'NEPd2:Data' on '/mnt/NEPd2/Data'..."
        mount /dev/mapper/NEPd2_Data /mnt/NEPd2/Data
    fi
}
NDPS1-system-mount q
