# Screenshot manager

function scrot-take() {
    date -Is > ~/TMP/date114514.tmp;
    sed -i 's/:/./g' ~/TMP/date114514.tmp
    sed -i 's/+00.00//g' ~/TMP/date114514.tmp
    sed -i 's/T/_/g' ~/TMP/date114514.tmp
    export SCROT_LATEST="~/scrot_`cat ~/TMP/date114514.tmp`.png"
    scrot -ub $SCROT_LATEST
    mv ~/scrot_*.png ~/PIC/Screenshots/
    rm ~/TMP/date114514.tmp
}
