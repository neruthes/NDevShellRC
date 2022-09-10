#!/bin/bash

if [[ "$HOSTNAME" != "NDLT6G" ]]; then
    echo "Not NDLT6G!"
fi

source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-desktop.sh
source $DEV_HOME_DIR/NDevShellRC/dev-spec/cat-gentoo.sh

if [[ -e $HOME/Pictures ]]; then
    rsync -av $HOME/Pictures/ $HOME/PIC/Default/
    rm -rf $HOME/Pictures
fi

export BROWSER="firefox-bin"

alias ttermusic="termusic ~/AUD/music"


####################################################
# NAS Management
####################################################
function NAS_sharedirpub() {
    srcdir="$(realpath "$1")"
    memorable_name="$2"
    if [[ -z $2 ]]; then
        memorable_name="$(basename "$srcdir")"
    fi
    destdir_name="TmpShare_$(date +%Y%m%d)--$memorable_name---$(uuidgen v4 | sed 's/-//g')"
    destdir="/mnt/NEPd3_Caster/LS/NAS_public/$destdir_name"
    echo "Symlink directory is at: $destdir"
    echo "https://nas-public.neruthes.xyz:2096/$destdir_name/"
    # echo "rsync://$(getlanip)/nas-public--$destdir_name/"
    ln -svf "$srcdir" "$destdir"
    # regenrsyncdconf > /dev/null
}
function regenrsyncdconf_nas-public() {
    CONFFILE=/etc/rsyncd.conf.d/50-nas-public
    sudo mkdir -p /etc/rsyncd.conf.d
    sudo rm $CONFFILE
    for idir in $(cat /mnt/NEPd3_Caster/LS/NAS_public/rsyncd.list); do
        sudo bash -c "echo -e '[nas-public--$(basename "$idir")]' >> $CONFFILE"
        sudo bash -c "echo -e 'path = /mnt/NEPd3_Caster/LS/NAS_public/$idir\n\n' >> $CONFFILE"
    done
}
function regenrsyncdconf() {
    # regenrsyncdconf_nas-public
    sudo bash -c 'cat /etc/rsyncd.conf.d/* > /etc/rsyncd.conf'
    cat /etc/rsyncd.conf
}

