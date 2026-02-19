#!/bin/bash

### Use this script to convert every page of PDF to PNG then aggregate back to PDF.

input_pdf_path="$1"
output_pdf_path="$2"
if [[ -z "$output_pdf_path" ]]; then
    output_pdf_path=/tmp/OUTPUT.pdf
else
    output_pdf_path="$(realpath "$output_pdf_path")"
fi



TMPDIR="$(mktemp -d)"
# Ensure cleanup on exit (normal or error)
trap "rm -r '$TMPDIR'" EXIT


cp "$input_pdf_path" "$TMPDIR/INPUT.pdf"

cd "$TMPDIR"

DPI=1200 gspdftopng INPUT.pdf

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
typst c OUTPUT.typ $TYPST_EXTRA_ARGS


cp OUTPUT.pdf "$output_pdf_path"



cd .. &&
echo rm -r "$TMPDIR"


du -h "$output_pdf_path"
