#!/bin/bash

### ----------------------------------------------------------------------------
### Environment Variables
PATH="$PATH:$HOME/.adb-fastboot/platform-tools"

### ----------------------------------------------------------------------------
### Normalize directory names
function _normalizeHomeDirs() {
    FROMDIR=$1
    TODIR=$2
    if [[ -r ~/$FROMDIR ]]; then
        rsync -av ~/$FROMDIR/ ~/$TODIR/ > /dev/null 2>&1
        rm -r ~/$FROMDIR
    fi
}
if [[ ! -e /.isChroot ]]; then
    _normalizeHomeDirs      Desktop         DOC/Desktop
    _normalizeHomeDirs      Downloads       DLD/Latest
    _normalizeHomeDirs      Recordings      AUD/Recordings
fi

### ----------------------------------------------------------------------------
### Downloads directory
function _mkDefaultDldSymlink() {
    if [[ "$USER" == "neruthes" ]]; then
        FULLDATE="$(date -Is)"
        YearMonthID=${FULLDATE:0:7}
        mkdir -p "$HOME/DLD/$YearMonthID"
        CURRENTYMID=$(basename $(readlink -f ~/DLD/Latest))
        if [[ "$CURRENTYMID" != "$YearMonthID" ]]; then
            rm ~/DLD/Latest
            ln -svf ~/DLD/$YearMonthID ~/DLD/Latest
        fi
    fi
}
_mkDefaultDldSymlink

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
        echo "[NOTICE] Last run of 'emerge --sync' was $DeltaTimeDay days ago."
    fi
fi
