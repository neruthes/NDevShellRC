#!/bin/bash

### Turn any file to a self-decrypting HTML

if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: ./encrypt_file.sh <filename>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$1.html"
MIME_TYPE=$(file --mime-type -b "$INPUT_FILE")
# Use openssl for a high-entropy hex password
PASSWORD=$(openssl rand -hex 16)
ITER=10000

# 1. Encrypt the file using OpenSSL compatible PBKDF2
ENC_DATA=$(openssl enc -aes-256-cbc -salt -pbkdf2 -iter $ITER -base64 -pass pass:"$PASSWORD" -in "$INPUT_FILE" | tr -d '\n')

cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Protected Asset</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
    <style>
        body { background: #ffffff; color: #000000; margin: 0; padding: 20px; font-family: sans-serif; }
        #viewer { width: 100%; height: 95vh; border: none; display: none; }
        #text-container { white-space: pre-wrap; font-family: monospace; word-break: break-all; }
        .loading { color: #888; font-style: italic; }
    </style>
</head>
<body>
    <div id="status" class="loading">Loading protected content...</div>
    <div id="container"></div>

    <script>
        const PAYLOAD = "$ENC_DATA";
        const MIME = "$MIME_TYPE";
        const PASS = "$PASSWORD";
        const ITER = $ITER;

        window.onload = function() {
            try {
                // 1. Parse and extract Salt/Ciphertext
                const fullWA = CryptoJS.enc.Base64.parse(PAYLOAD);
                const salt = CryptoJS.lib.WordArray.create(fullWA.words.slice(2, 4));
                const ciphertext = CryptoJS.lib.WordArray.create(fullWA.words.slice(4), fullWA.sigBytes - 16);

                // 2. Derive Key/IV (48 bytes for AES-256 + IV)
                const derivedParams = CryptoJS.PBKDF2(PASS, salt, {
                    keySize: 48 / 4,
                    iterations: ITER,
                    hasher: CryptoJS.algo.SHA256
                });

                const key = CryptoJS.lib.WordArray.create(derivedParams.words.slice(0, 8));
                const iv = CryptoJS.lib.WordArray.create(derivedParams.words.slice(8, 12));

                // 3. Decrypt
                const decrypted = CryptoJS.AES.decrypt(
                    { ciphertext: ciphertext },
                    key,
                    { iv: iv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 }
                );

                // 4. Handle rendering based on type
                if (MIME.startsWith('text/')) {
                    // XSS Prevention: Convert binary to string, then to Unicode Entities
                    const rawText = decrypted.toString(CryptoJS.enc.Utf8);
                    if (!rawText) throw new Error("Empty or Corrupt Content");
                    
                    renderText(rawText);
                } else {
                    // For binary (PDF, Images, Video), use Data URI
                    const b64 = decrypted.toString(CryptoJS.enc.Base64);
                    renderMedia("data:" + MIME + ";base64," + b64);
                }
                
                document.getElementById('status').style.display = 'none';
            } catch (e) {
                document.getElementById('status').textContent = "Failed to load content.";
                console.error(e);
            }
        };

        function renderText(text) {
            const container = document.getElementById('container');
            const wrapper = document.createElement('div');
            wrapper.id = "text-container";
            
            // Turn every character into a unicode entity &#x...;
            let escaped = "";
            for (let i = 0; i < text.length; i++) {
                escaped += "&#" + text.charCodeAt(i) + ";";
            }
            
            wrapper.innerHTML = escaped;
            container.appendChild(wrapper);
        }

        function renderMedia(uri) {
            const container = document.getElementById('container');
            let el;
            
            if (MIME.startsWith('image/')) {
                el = document.createElement('img');
            } else if (MIME.startsWith('video/')) {
                el = document.createElement('video');
                el.controls = true;
            } else if (MIME.startsWith('audio/')) {
                el = document.createElement('audio');
                el.controls = true;
            } else {
                el = document.createElement('iframe');
            }
            
            el.id = "viewer";
            el.style.display = "block";
            el.src = uri;
            container.appendChild(el);
        }
    </script>
</body>
</html>
EOF

echo "Secure HTML created: $OUTPUT_FILE"
