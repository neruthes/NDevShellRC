#!/bin/bash

if [[ "$(hostname)" != "NDPS3" ]]; then
    echo "Not NDPS3!" >/dev/stderr
    exit 1
fi

function NDPS1-system-mount() {
    isQUIET=$1

    function qecho() {
        if [[ "x$isQUIET" == 'x' ]]; then
            echo $1 >/dev/stderr
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

    if [[ -r /mnt/NEPd2_Archer/ls/.mounted ]]; then
        qecho "Already mounted 'NEPd2:Data'."
    else
        qecho "Decrypting 'NEPd2:Data'..."
        cryptsetup open /dev/disk/by-partlabel/NEPd2_Data NEPd2_Data -d /home/neruthes/.MyLuksKey
        qecho "Mounting 'NEPd2:Data' on '/mnt/NEPd2_Archer/ls'..."
        mount /dev/mapper/NEPd2_Data /mnt/NEPd2_Archer/ls
        qecho "Starting Docker daemon..."
        systemctl start docker
        docker start n.mariadb2 &
        docker start n.nextcloud1 &
        docker ps
    fi
}
#NDPS1-system-mount q
