function NDev-SSH() {
    # arg1: Target Device
    echo ssh -i "~/.ssh/$(hostname).pub" "neruthes@$1.$(pas p NDev-cloudflare-ddns-midfix).neruthes.xyz"
}
