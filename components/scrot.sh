# Screenshot manager

function scrot-take() {
    date -Is > ~/TMP/SCROT_LATEST.tmp;
    sed -i 's/:/./g' ~/TMP/SCROT_LATEST.tmp
    sed -i 's/+00.00//g' ~/TMP/SCROT_LATEST.tmp
    sed -i 's/T/_/g' ~/TMP/SCROT_LATEST.tmp
    SCROT_LATEST_INNER="`cat ~/TMP/SCROT_LATEST.tmp`"
    scrot -ub "$HOME/scrot_$SCROT_LATEST_INNER.png"
    mv $HOME/scrot_*.png $HOME/PIC/Screenshots/
    export SCROT_LATEST="$HOME/PIC/Screenshots/scrot_$SCROT_LATEST_INNER.png"
    #rm ~/TMP/SCROT_LATEST.tmp
}
