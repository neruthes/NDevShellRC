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

# Get the size of the input PDF (width and height in points)
cpdf "$input_pdf" -info | grep "MediaBox"
input_size="$(cpdf "$input_pdf" -info | grep "MediaBox")"

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
scale="$(echo "$input_height / $a4_height" | bc -l)"

# echo "input_size=$input_size"
# echo "a4_height=$a4_height  input_width=$input_width  input_height=$input_height"
# echo "scale=$scale"

pdfjam --paper a4 --offset "${offset_x}pt ${offset_y}pt" --scale "$scale" "$input_pdf" --outfile "$output_pdf"

printf '\n\n'
echo "Output: $(realpath "$output_pdf")"

