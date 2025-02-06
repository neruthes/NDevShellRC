#!/bin/bash


############################################################################
# put_pdf_onto_a4_canvas.sh
#
# Copyright (c) 2025 Neruthes. Published with the MIT license.
#
# This script puts arbitrary PDF onto A4 canvas.
# Runtime dependencies: cpdf, pdfjam
############################################################################


# Input PDF file
input_pdf="$1"
output_pdf="$2"

if [[ ! -e "$1" ]] || [[ -z "$2" ]]; then
	echo "Usage:   $(basename "$0")  input.pdf  output.pdf"
	exit 1
fi

if ! command -v cpdf || ! command -v pdfjam; then
	echo "Runtime dependencies:  cpdf, pdfjam"
	exit 1
fi


### Flatten the PDF
pdf2ps "$input_pdf" - | ps2pdf - "$output_pdf.tmp.pdf"
# pdf2ps orig.pdf - | ps2pdf - flattened.pdf 


# Get the size of the input PDF (width and height in points)
cpdf "$input_pdf" -info | grep "MediaBox"
cpdf "$output_pdf.tmp.pdf" -info | grep "MediaBox"
input_size="$(cpdf "$output_pdf.tmp.pdf" -info | grep "MediaBox")"

# Parse the width and height
input_width="$(echo "$input_size" | cut -d' ' -f4)"
input_height="$(echo "$input_size" | cut -d' ' -f5)"

# A4 size in points (595x842 for portrait)
a4_width=595.28
a4_height=841.89


# offset_x="$(echo "($a4_width - $input_width) * 0.5" | bc -l)"
offset_y="$(echo "($a4_height - $input_height) * 0.5" | bc -l)"
offset_x=0
# offset_y=0

scale=1
scale="$(echo "$input_width / $a4_width" | bc -l)"

echo "input_size=$input_size"
echo "input_width=$input_width"
echo "input_height=$input_height"
echo "scale=$scale"

pdfjam --paper a4 --offset "${offset_x}pt ${offset_y}pt" --scale "$scale" "$output_pdf.tmp.pdf" --outfile "$output_pdf"

printf '\n\n'
echo "Output: $(realpath "$output_pdf")"

rm "$output_pdf.tmp.pdf"
