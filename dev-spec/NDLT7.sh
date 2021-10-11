#!/bin/bash

if [[ "$(hostname)" != "NDLT7" ]]; then
    echo "Not NDLT7!"
    exit 1
fi

source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-desktop.sh

if [[ -e $HOME/Pictures ]]; then
    rsync -av $HOME/Pictures/ $HOME/PIC/Default/
    rm -rf $HOME/Pictures
fi

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


### ----------------------------------------------------------------------------
### Portage
alias fullupdate="sudo emerge --verbose --update --newuse --tree --complete-graph --ask=n --with-bdeps=y --autounmask-continue --keep-going @world"

### ----------------------------------------------------------------------------
### Kernel
function buildMyKernelNow() {
    if [[ $PWD != /usr/src/linux ]]; then
        echo "[ERROR] This command can only be used in '/usr/src/linux'."
        return 1
    fi
    source /etc/portage/make.conf
    sudo make -j8 all
    sudo make modules_install
    sudo make install
    sudo genkernel initramfs
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo emerge @module-rebuild --ask=n
}

### ----------------------------------------------------------------------------
### Miscellaneous
# alias startlutris="INSIDE CHROOT    sudo -u player daemonize $(which proxychains) lutris"