#!/bin/bash

TMPSH=.tmp_embeded_recipe_$RANDOM$RANDOM$RANDOM.sh

input_file="$1"
export EXTRACT_RECIPE_SOURCE_FILE="$input_file"

function get_prefix_length() {
    heading_line="$1"
    prefix_length="$(cut -dB -f1 <<< "$heading_line" | wc -c)"
    # prefix_length=$((prefix_length - 1))
    echo "$prefix_length"

}

grep -qs 'BEGIN DANGEROUS SHELL INJECTION$' "$input_file" || exit 1
grep -qs 'END DANGEROUS SHELL INJECTION$' "$input_file" || exit 1

begin_line_num="$(grep -n 'BEGIN DANGEROUS SHELL INJECTION$' "$input_file" | head -n 1 | cut -d: -f1)"
end_line_num="$(grep -n 'END DANGEROUS SHELL INJECTION$' "$input_file" | head -n 1 | cut -d: -f1)"

echo "begin_line_num=$begin_line_num"
echo "end_line_num=$end_line_num"


heading_line="$(head -n "$begin_line_num" "$input_file" | tail -n 1)"
prefix_length="$(get_prefix_length "$heading_line")"

head -n "$((end_line_num - 1))" "$input_file" | tail -n $((end_line_num - begin_line_num - 1)) | cut -c"$prefix_length"- > "$TMPSH"

ls "$TMPSH"
echo ==================================
cat "$TMPSH"

bash "$TMPSH"

rm -v "$TMPSH"
