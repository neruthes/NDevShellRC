# Pull personal shell utils

function NDev-Sync--landdns() {
    node -e "process.stdout.write('Publishing LAN DDNS... ')"
    DOMAIN_NAME="$(hostname).$(pas p NDev-cloudflare-ddns-midfix).neruthes.xyz"
    MY_LAN_IP_ADDR=`ifconfig | grep "inet " | grep -e "\(0xffffff00\|255.255.255.0\)" | xargs node -e "console.log(process.argv[2])"`
    curl --show-error -s -X PUT "https://api.cloudflare.com/client/v4/zones/cef23400ccfef7aa9511988f2e27b181/dns_records/$(pas p oid.cloudflare.xyz.neruthes.ndev-`hostname`)" \
        -H "Authorization: Bearer `pas p token.cloudflare.OmniDnsToken`" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"${DOMAIN_NAME}\",\"content\":\"${MY_LAN_IP_ADDR}\",\"ttl\":120,\"proxied\":false}" > /tmp/6508d65e-8da7-441f-b371-b77d2a621859.txt
    node -e "JSON.parse(fs.readFileSync('/tmp/6508d65e-8da7-441f-b371-b77d2a621859.txt').toString()).success ? console.log('Success.') : console.log('Failed.')"
    # rm /tmp/6508d65e-8da7-441f-b371-b77d2a621859.txt
}

function NDev-Sync() {
    LASTSYNC=`cat /tmp/NDev-Sync--LastSyncTimestamp.txt`
    node -e "console.log('Last sync ' + (new Date($LASTSYNC)).toISOString().replace('T', ' ').replace(/\.\d{3}Z$/, '') + ' (' + Math.floor( (Date.now()-(new Date($LASTSYNC)))/1000/60 ) + ' min ago).');"
    echo "`date +%s`000" > /tmp/NDev-Sync--LastSyncTimestamp.txt
    NDev-Sync--landdns

    mypwd=$PWD
    cd $DEV_HOME_DIR/NDevMgr && git pull && u
    cd $DEV_HOME_DIR/NDevShellRC && git pull && u
    cd $DEV_HOME_DIR/NDevMsgInbox && git pull && u
    clipass-sync
    [[ "$0" = *bash* ]] && source ~/.bashrc || source ~/.zshrc
    cd $mypwd
}
