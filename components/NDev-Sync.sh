# Pull personal shell utils

function NDev-Sync--ifconfig() {
    date +"%Y-%m-%d %H:%M:%S UTC" > /tmp/latest-ifconfig.txt
    ifconfig | grep "inet " >> /tmp/latest-ifconfig.txt
    ntge encrypt -r NDLT6 -r NDLT7 -r NDLT7W -o "$DEV_HOME_DIR/NDevMgr/ifconfig/$(hostname).ntge.txt" -p /tmp/latest-ifconfig.txt
    rm /tmp/latest-ifconfig.txt
}

function NDev-Sync--landdns() {
    echo 'Publishing LAN DDNS...'
    DOMAIN_NAME="$(hostname).$(pas p NDev-cloudflare-ddns-midfix).neruthes.xyz"
    MY_LAN_IP_ADDR=`ifconfig | grep "inet " | grep "0xffffff00" | xargs node -e "console.log(process.argv[2])"`

    curl -X PUT "https://api.cloudflare.com/client/v4/zones/cef23400ccfef7aa9511988f2e27b181/dns_records/$(pas p oid.cloudflare.xyz.neruthes.ndev-`hostname`)" \
        -H "Authorization: Bearer `pas p token.cloudflare.OmniDnsToken`" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"${DOMAIN_NAME}\",\"content\":\"${MY_LAN_IP_ADDR}\",\"ttl\":120,\"proxied\":false}"

}

function NDev-Sync() {
    node -e "fs.writeFileSync('/tmp/NDevSyncHelper-LastSyncTimestamp.txt', Date.now().toString())"
    NDev-Sync--landdns
    mypwd=$PWD

    cd $DEV_HOME_DIR/NDevMgr && git pull && u
    cd $DEV_HOME_DIR/NDevShellRC && git pull && u
    cd $DEV_HOME_DIR/NDevMsgInbox && git pull && u
    clipass-sync
    cd $mypwd
}
