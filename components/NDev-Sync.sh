# Pull personal shell utils

function NDev-Sync() {
    mypwd=$PWD
    cd $DEV_HOME_DIR/NDevShellRC && git pull && u
    cd $DEV_HOME_DIR/NDevMsgInbox && git pull && u
    clipass-sync
    cd mypwd
}
