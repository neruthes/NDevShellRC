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

function rsyncBackupNDev--NEPd2_Data_WWW--NEPd3_LS() {
    if [[ ! -e /mnt/NEPd3_Caster/LS/.fsroot ]]; then
        echo "Error: Disk volume 'NEPd3_LS' is not mounted!"
    fi
    sudo rsync -avz -e ssh --progress root@NDPS1.lan:/mnt/NEPd2/Data/WWW/ /mnt/NEPd3_Caster/LS/Backup-NEPd2_Data/WWW/
}
function rsyncBackupNDev--NEPd3_LS_BorgHome--NEPd2_Data() {
    if [[ ! -e /mnt/NEPd3_Caster/LS/.fsroot ]]; then
        echo "Error: Disk volume 'NEPd3_LS' is not mounted!"
    fi
    sudo rsync -avz -e ssh --progress /mnt/NEPd3_Caster/LS/BorgHome/ root@NDPS1.lan:/mnt/NEPd2/Data/Backup-NEPd3_LS/BorgHome/
}
