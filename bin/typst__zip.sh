#!/bin/bash

FN="$1"

[[ "$FN" == *.typ ]] || { echo "[ERROR] Input file must be Typst source document."; exit 1; }

[[ -e RUNME.sh ]] && { echo "[ERROR] Must delete RUNME.sh!"; exit 2; }

cat > RUNME.sh <<EOF
#!/bin/bash
typst c --root . '$FN'
realpath '$FN' | xargs du -h
EOF

typst c --root . "$1" -f pdf /dev/null --deps /dev/stdout | jq -r '.inputs[]'  | grep -v '^/' | grep -v NOZIP | xargs zip -R "$FN"--BUNDLE.zip RUNME.sh


rm RUNME.sh