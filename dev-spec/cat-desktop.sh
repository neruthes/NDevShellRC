#!/bin/bash

alias pc='proxychains -q'

### ----------------------------------------------------------------------------
### Environment Variables

### ----------------------------------------------------------------------------
### Normalize directory names
function _normalizeHomeDirs() {
    FROMDIR=$1
    TODIR=$2
    if [[ -r $HOME/$FROMDIR ]]; then
        rsync -av $HOME/$FROMDIR/ $HOME/$TODIR/ > /dev/null 2>&1
        rm -r $HOME/$FROMDIR
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
        CURRENTYMID=$(basename $(readlink -f $HOME/DLD/Latest))
        if [[ "$CURRENTYMID" != "$YearMonthID" ]]; then
            rm $HOME/DLD/Latest
            ln -svf $HOME/DLD/$YearMonthID $HOME/DLD/Latest
        fi
    fi
}
_mkDefaultDldSymlink


