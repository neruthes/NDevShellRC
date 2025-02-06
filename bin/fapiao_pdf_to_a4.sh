#!/bin/bash

input_pdf="$1"
output_pdf="$(sed 's|.pdf.out$|-a4.pdf|' <<< "$1.out")"



cpdf -scale-contents 0.87 -topright 4mm "$input_pdf" -o "$output_pdf.tmp.pdf"
cpdf -scale-to-fit a4portrait -top 0 "$output_pdf.tmp.pdf" -o "$output_pdf"

rm "$output_pdf.tmp.pdf"

realpath "$output_pdf"
