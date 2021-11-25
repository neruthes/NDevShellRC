#!/bin/bash

if [[ "$HOSTNAME" != "NDLT7" ]]; then
    echo "Not NDLT7!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-desktop.sh

if [[ -e $HOME/Pictures ]]; then
    rsync -av $HOME/Pictures/ $HOME/PIC/Default/
    rm -rf $HOME/Pictures
fi

export BROWSER="firefox-bin"

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
    if [[ -e /mnt/NEPd3_Caster/LS/.fsroot ]]; then
        for i in etc usr var root opt lib lib64 boot srv bin sbin home; do
            sudo rsync -avp --one-file-system --delete --progress /$i/ /mnt/NEPd3_Caster/LS/BackupCenter/NDLT7/$i/
        done
    else
        echo "Error: Disk volume 'NEPd3_LS' is not mounted!"
    fi
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


### ----------------------------------------------------------------------------
### Portage
# alias fullupdate="sudo emerge --verbose --update --newuse --tree --complete-graph --ask=n --with-bdeps=y --autounmask-continue --keep-going @world"
alias fullupdate="sudo emerge -vuDN --tree --keep-going @world"

### ----------------------------------------------------------------------------
### Kernel
function buildMyKernelNow() {
    cd /usr/src/linux
    source /etc/portage/make.conf
    sudo make -j3 all
    sudo make modules_install
    sudo make install
    sudo emerge @module-rebuild --ask=n
    pregenkernel
    sudo genkernel initramfs
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

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

alias pa_z420="env PULSE_SERVER=10.0.233.20"

if [[ "$(tty)" == "/dev/tty1" ]]; then
    FORK=y psman-init
fi