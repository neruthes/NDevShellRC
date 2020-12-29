#!/bin/bash

if [[ "$(hostname)" != "NDPS1" ]]; then
    echo "Not NDPS1!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/components/cli.sh
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh
source $DEV_HOME_DIR/NDevShellRC/components/git.sh
source $DEV_HOME_DIR/NDevShellRC/components/pbcopy.sh
source $DEV_HOME_DIR/NDevShellRC/components/proxy.sh

tcprpserver 8080 10.104.22.2 8080
tcprpserver 16001 172.17.0.2 3306

function NDPS1-system-mount() {
    isQUIET=$1

    function qecho() {
        if [[ "x$isQUIET" == 'x' ]]; then
            echo $1
        fi
    }

    if [[ -r /usr/.mounted ]]; then
        qecho "Already mounted '/usr'."
    else
        qecho "Mounting '/usr'..."
        mount --rbind /mnt/NEPd2/PS1Ext/Main/usr /usr
    fi

    if [[ -r /var/.mounted ]]; then
        qecho "Already mounted '/var'."
    else
        qecho "Mounting '/var'..."
        mount --rbind /mnt/NEPd2/PS1Ext/Main/var /var
    fi

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
        qecho "Starting Docker daemon..."
        systemctl start docker
        docker start n.mariadb2 &
        docker start n.nextcloud1 &
        docker ps
    fi
}
NDPS1-system-mount q

function docker-NDPS1-cron-trigger() {
    docker exec -it -u 33 n.nextcloud1 /var/www/html/_rescan.sh
}

function OTHERUTILS-docker-nextcloud() {
    printf ""
    # docker run -d \
    #     --mount src=/mnt/NEPd2/Data/WWW/n.nextcloud1/var/www/html,target=/var/www/html,type=bind \
    #     --name n.nextcloud1 \
    #     nextcloud
    # docker exec -it \
    #     -v /mnt/NEPd2/Data/WWW/xyz.neruthes.nextcloud/var:/var \
    #     xyz.neruthes.nextcloud bash
    # docker run -d \
    #     --mount src=/mnt/NEPd2/Data/WWW/n.mariadb2/var/lib/mysql,target=/var/lib/mysql,type=bind \
    #     --name n.mariadb2 \
    #     -e MYSQL_ROOT_PASSWORD=$(pasm p n.mariadb2) \
    #     mariadb

}

function Docker-n.nextcloud1-rescanfiles() {
    ### Nextcloud: Rescan files
    docker exec -it n.nextcloud1 /var/www/html/_chown.sh
    docker exec -it -u 33 n.nextcloud1 /var/www/html/_rescan.sh
}
