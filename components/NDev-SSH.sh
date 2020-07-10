function NDevSSH() {
    # arg1: Target Device
    ssh -i "~/.ssh/$(hostname)" "neruthes@$1.$(pas p NDev-cloudflare-ddns-midfix).neruthes.xyz"
}
