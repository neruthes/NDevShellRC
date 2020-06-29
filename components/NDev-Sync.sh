# Pull personal shell utils

function NDev-Sync--ifconfig() {
    date +"%Y-%m-%d %H:%M:%S UTC" > /tmp/latest-ifconfig.txt
    ifconfig | grep "inet " >> /tmp/latest-ifconfig.txt
    ntge encrypt -r NDLT6 -r NDLT7 -r NDLT7W -o "$DEV_HOME_DIR/NDevMgr/ifconfig/$(hostname).ntge.txt" -p /tmp/latest-ifconfig.txt
    rm /tmp/latest-ifconfig.txt
}

function NDev-Sync() {
    node -e "fs.writeFileSync('/tmp/NDevSyncHelper-LastSyncTimestamp.txt', Date.now().toString())"
    mypwd=$PWD
    cd $DEV_HOME_DIR/NDevMgr && git pull && u
    cd $DEV_HOME_DIR/NDevShellRC && git pull && u
    cd $DEV_HOME_DIR/NDevMsgInbox && git pull && u
    clipass-sync
    NDev-Sync--ifconfig
    cd $mypwd
}
