#!/usr/bin/env bash
set -euo pipefail

CERT_DIR="/usr/share/ca-certificates/mozilla"

# STD controls output mode
# if non-empty -> emit p11-kit blocklist lines
STD="${STD:-}"

emit_blocklist=0
if [[ -n "$STD" ]]; then
    emit_blocklist=1
fi

for cert in "$CERT_DIR"/*.crt; do
    subject=$(openssl x509 -in "$cert" -noout -subject 2>/dev/null || true)
    [[ -z "$subject" ]] && continue

    country=$(echo "$subject" | sed -n 's/.*C=\([^,/]*\).*/\1/p')

    [[ "$country" != "CN" ]] && continue

    fp=$(openssl x509 -in "$cert" -noout -fingerprint -sha256 2>/dev/null \
        | cut -d= -f2 | tr -d ':')

    # derive stable pkcs11-like id (deterministic placeholder form)
    # NOTE: real pkcs11:id is token-specific; this mimics p11-kit formatting style
    pkcs_id=$(echo -n "$fp" | sed 's/../%&/g')

    label=$(echo "$subject" | sed 's/.*CN *= *\([^,/]*\).*/\1/')

    if [[ "$emit_blocklist" -eq 1 ]]; then
        echo "blocklist: pkcs11:id=${pkcs_id};type=cert"
    else
        echo "filename=$(basename "$cert")"
        echo "subject=$subject"
        echo "sha256=$fp"
        echo "country=$country"
        echo "----"
    fi
done



echo "[HINT] Run this script with env 'STD=y' and write stdout to this file."
echo '        ' /etc/ca-certificates/trust-source/bjca-distrust.p11-kit

echo ''
echo sudo update-ca-certificates --fresh
echo sudo trust extract-compat
echo trust list '|' grep -i 'SOME_CA_NAME'
