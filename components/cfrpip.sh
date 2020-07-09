# CloudFlare Reverse Proxy IP

function cfrpip() {
    node -e "process.stdout.write('Publishing LAN DDNS... ')"
    DOMAIN_NAME="httpd.neop.me"
    curl --show-error -s -X PUT "https://api.cloudflare.com/client/v4/zones/4882239e5082c3980e2deee3ad1b93fd/dns_records/$(pas p oid.cloudflare.me.neop.httpd)" \
        -H "Authorization: Bearer `pas p token.cloudflare.OmniDnsToken`" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"${DOMAIN_NAME}\",\"content\":\"$1\",\"ttl\":120,\"proxied\":true}" > /tmp/6508d65e-8da7-441f-b371-b77d2a621860.txt
    node -e "JSON.parse(fs.readFileSync('/tmp/6508d65e-8da7-441f-b371-b77d2a621860.txt').toString()).success ? console.log('Success.') : console.log('Failed.')"
    # rm /tmp/6508d65e-8da7-441f-b371-b77d2a621860.txt
}
