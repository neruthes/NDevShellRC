function nextcloud-docker-run() {
    # Nextcloud
    docker run -t -dp 80:80 nextcloud

    # DDNS over CloudFlare
    docker run \
        -e API_KEY="`pas p cloudflare.token.dns--udon.pw`" \
        -e ZONE=udon.pw \
        -e SUBDOMAIN=nextcloud-i1 \
        -e PROXIED=true \
        oznu/cloudflare-ddns

}
