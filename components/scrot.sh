# Screenshot manager

function scrot-linux() {
    date -Is > ~/TMP/date114514.tmp && scrot -ub "scrot_`sed -i 's/:/./g' ~/TMP/date114514.tmp && sed -i 's/+00.00//g' ~/TMP/date114514.tmp && sed -i 's/T/_/g' ~/TMP/date114514.tmp && cat ~/TMP/date114514.tmp `.png" -e 'mv ~/scrot_*.png ~/NET/Syncthing/Neruthes-Syncthing-N1/Screenshots/' && rm ~/TMP/date114514.tmp
}
