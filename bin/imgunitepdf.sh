#!/bin/bash

# Use this script to convert every page of PDF to PNG then aggregate back to PDF.

input_pdf_path="$1"

TMPDIR="/tmp/$USER.$(date +%s)"
mkdir -p "$TMPDIR"

cp "$input_pdf_path" "$TMPDIR/INPUT.pdf"

cd "$TMPDIR"

DPI=600 gspdftopng INPUT.pdf

ls

rm INPUT.pdf

(
    echo '#set page(paper: "a4", margin: 0mm)'
    echo ""
    find . -name '*.png' | sort -h | while read -r png; do
        printf '#page(image("%s", width: 100%%, height: 100%%, fit: "cover"))\n' "$png"
        echo ""
    done
) > OUTPUT.typ

cat OUTPUT.typ
typst c OUTPUT.typ


cp OUTPUT.pdf /tmp/OUTPUT.pdf



cd .. &&
rm -r "$TMPDIR"


du -h /tmp/OUTPUT.pdf
