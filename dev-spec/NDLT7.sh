#!/bin/bash

if [[ "$HOSTNAME" != "NDLT7" ]]; then
    echo "Not NDLT7!"
fi

source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-desktop.sh
source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-gentoo.sh

if [[ -e $HOME/Pictures ]]; then
    rsync -av $HOME/Pictures/ $HOME/PIC/Default/
    rm -rf $HOME/Pictures
fi

export BROWSER="firefox-bin"




### ----------------------------------------------------------------------------
### LAN filesystems
function mountsshfs() {
    REMOTE_HOST="$1"
    if [[ "$REMOTE_HOST" == "ND"* ]]; then
        SSH_USER="root"
    else
        SSH_USER="$USER"
    fi
    DIRPATH="/mnt/sshfs/${REMOTE_HOST}"

    ### Create directory
    if [[ ! -e "$DIRPATH" ]]; then
        sudo mkdir -p "$DIRPATH"
        sudo chown root:wheel "$DIRPATH"
        sudo chmod 775 "$DIRPATH"
    fi

    ### Mount if not mounted
    if [[ "$(mount | grep "on $DIRPATH")" == "" ]]; then
        echo sshfs "$SSH_USER@${REMOTE_HOST}:/" "$DIRPATH"
        sshfs "$SSH_USER@${REMOTE_HOST}:/" "$DIRPATH"
    else
        echo "Directory '$DIRPATH' has already been mounted."
    fi
}





### ----------------------------------------------------------------------------
### Data backup operations
function rsyncBackupNDev--NEPd2_Data_WWW--NEPd3_LS() {
    if [[ -e /mnt/NEPd3_Caster/LS/.fsroot ]]; then
        sudo rsync -avz -e ssh --progress root@NDPS1.lan:/mnt/NEPd2/Data/WWW/ /mnt/NEPd3_Caster/LS/Backup-NEPd2_Data/WWW/
    else
        echo "Error: Disk volume 'NEPd3_LS' is not mounted!"
    fi
}
function rsyncBackupNDev--NEPd3_LS_BorgHome--NEPd2_Data() {
    if [[ -e /mnt/NEPd3_Caster/LS/.fsroot ]]; then
        sudo rsync -avz -e ssh --progress /mnt/NEPd3_Caster/LS/BorgHome/ root@NDPS1.lan:/mnt/NEPd2/Data/Backup-NEPd3_LS/BorgHome/
    else
        echo "Error: Disk volume 'NEPd3_LS' is not mounted!"
    fi
}
function rsyncBackupNDev--NDLT7--NEPd3--baselayout() {
    #if [[ -e neruthes@10.0.233.10:/mnt/NEPd3_Caster/LS/.fsroot ]]; then
        for i in etc usr var root opt lib lib64 boot srv bin sbin home; do
            sudo rsync -avp --one-file-system --delete --progress /$i/ root@10.0.233.10:/mnt/NEPd3_Caster/LS/BackupCenter/NDLT7/$i/
        done
    #else
    #    echo "Error: Disk volume 'NEPd3_LS' is not mounted!"
    #fi
}
function rsyncBackupNDev--NDLT7--NEPd3--home() {
    sudo rsync -avp --one-file-system --delete --progress /home/ root@10.0.233.10:/mnt/NEPd3_Caster/LS/BackupCenter/NDLT7/home/
}
# From and to NDLT6
function ndrsyncpush() {
    rsync -av --exclude={'*/.git','**/.git','*/*/.git','*/*/*/.git','.*'} \
        /home/neruthes/DOC/ \
        neruthes@10.0.233.126:/Users/Neruthes/Documents/
}
function ndrsyncpull() {
    rsync -av --exclude={'*/.git','**/.git','*/*/.git','*/*/*/.git','.*'} \
        neruthes@10.0.233.126:/Users/Neruthes/Music/GarageBand/ \
        /home/neruthes/AUD/GarageBand/
    rsync -av --exclude={'*/.git','**/.git','*/*/.git','*/*/*/.git','.*'} \
        neruthes@10.0.233.126:/Users/Neruthes/Documents/Design/ \
        /home/neruthes/DOC/Design/
}
# NAS on NDLT6G
function NAS_push-music() {
    rsync -av --delete --progress $HOME/AUD/music/ $USER@NDLT6G:/home/neruthes/AUD/music/
    ssh NDLT6G 'rsync -av --delete --progress /home/neruthes/AUD/music/ /mnt/NEPd3_Caster/LS/NAS/Music/Base/'
}


### ----------------------------------------------------------------------------
### System update alert
if [[ "${NDEV_OS}" == "Gentoo" ]]; then
    MyTmpVar1="$(stat /var/db/repos/gentoo/.git | grep Modify)"
    MyTmpVar2="${MyTmpVar1:8:19}"
    LatestUpdateTimestamp="$(date --date="$MyTmpVar2" +%s)"
    CurrentTimestamp="$(date +%s)"
    DeltaTimeSec="$(($CurrentTimestamp - $LatestUpdateTimestamp))"
    DeltaTimeDay="$(($DeltaTimeSec / 3600 / 24))"
    # echo "It has been $DeltaTimeSec seconds since last 'emerge --sync'."
    if [[ "$DeltaTimeDay" > "7" ]]; then
        echo "[NOTICE] Last run of 'emerge --sync' was $DeltaTimeDay days ago." >&2
    fi
fi



### ----------------------------------------------------------------------------
### Miscellaneous
# alias startlutris="INSIDE CHROOT    sudo -u player daemonize $(which proxychains) lutris"
function _checkMortalityAlert() {
    if [[ "$USER" != "neruthes" ]]; then
        ### Not for any other user
        return 0
    fi
    if [[ "$SSH_TTY" != "" ]]; then
        ### Must not be inside SSH
        return 0
    fi
    RealPWD="$PWD"
    cd /home/neruthes/DEV/neruthes.github.io
    OLDDATE="$(git log -1 --format=%at)"
    NOWDATE="$(date +%s)"
    DELTASECS="$((NOWDATE-OLDDATE))"
    DELTAHOURS="$((DELTASECS/3600))"
    if [[ "$DELTAHOURS" -lt "24" ]]; then
        cd "$RealPWD"
        return 0
    fi
    NEED_UPDATE=n
    echo "$DELTAHOURS hours since last postpone mortality alert. Update now? (y/n)">&2
    printf "> ">&2
    read NEED_UPDATE
    if [[ "$NEED_UPDATE" == "y" ]]; then
        echo "Running script...">&2
        daemonize -c "$PWD" /bin/bash "$PWD/postponemortalityalert.sh"
    fi
    cd "$RealPWD"
}
_checkMortalityAlert

alias pa_Z420="PULSE_SERVER=10.0.233.20"
alias pa_NDLT6G="PULSE_SERVER=10.0.233.10"
alias ttermusic="termusic ~/AUD/music"

if [[ "$(tty)" == "/dev/tty1" ]]; then
    FORK=y psman-init
    daemonize /usr/bin/sudo /sbin/rc-service ntp-client restart
    daemonize /usr/bin/sudo /sbin/rc-service shadowsocks-rust.client restart
fi





### Homoweb Components Tree
export HOMOWEBREPO="/home/neruthes/EWS/stn/homoweb/homoweb-tree/TREE"
