#!/bin/bash

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
