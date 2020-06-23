# Screen Manager

function scrmgr-ndlt7-dual-mount-InternalImplementation() {
    # $1 = String like "2560x1440" for resolution
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --mode $1 --pos 1920x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off
}

function scrmgr-ndlt7-dual-autosetup() {
    node $DEV_HOME_DIR/NDevShellRC/components/nodejs/scrmgr-ndlt7-dual-autosetup.js
}
