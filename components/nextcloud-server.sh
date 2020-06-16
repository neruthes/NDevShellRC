function nextcloud-i1-server-start() {
    # Nextcloud
    docker run -t -dp 2087:80 \
        --name nextcloud-i1 \
        --mount type=bind,source=/Users/Neruthes/.Nextcloud-i1-Server/var-www-html,target=/var/www/html,consistency=consistent \
        nextcloud

    # DDNS over CloudFlare
    docker run -d \
        --name cloudflare-ddns-nci1 \
        -e API_KEY="`pas p cloudflare.token.dns--udon.pw`" \
        -e ZONE=udon.pw \
        -e SUBDOMAIN=nextcloud-i1 \
        -e PROXIED=true \
        oznu/cloudflare-ddns
}

function nextcloud-i1-server-halt() {
    docker stop nextcloud-i1
    docker rm nextcloud-i1
    docker stop cloudflare-ddns-nci1
    docker rm cloudflare-ddns-nci1
}
