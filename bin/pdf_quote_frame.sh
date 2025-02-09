#!/bin/bash

#########################################################################################
# The 'pdf_quote_frame.sh' script
#
# Copyright 2021-2025 Neruthes (https://neruthes.xyz) (https://github.com/neruthes).
# Published with the MIT license (https://mit-license.org/).
#########################################################################################






### Initialize default values
DEFAULT_FOOTER_LEFT="%Y/%b/%d %a %T"
DEFAULT_FOOTER_RIGHT="Page %Page of %EndPage"
# SHIFT_Y="-12.3mm"
SHIFT_Y="-9.3mm"


[[ -e "$HOME/.config/pdf_quote_frame.sh.env" ]] && source "$HOME/.config/pdf_quote_frame.sh.env"
[[ -e ".env" ]] && source ".env"


### Overwrite supplied vars
[[ -z $REAL_FOOTER_LEFT ]] && REAL_FOOTER_LEFT="$DEFAULT_FOOTER_LEFT $EXTRA_FOOTER_LEFT"
[[ -z $REAL_FOOTER_RIGHT ]] && REAL_FOOTER_RIGHT="$EXTRA_FOOTER_RIGHT $DEFAULT_FOOTER_RIGHT"
[[ -z $FOOTER_POS_LEFT ]] && FOOTER_POS_LEFT="21.1mm 10mm"
[[ -z $FOOTER_POS_RIGHT ]] && FOOTER_POS_RIGHT="200mm 10mm"


[[ -z "$FRAME" ]] && FRAME=/home/neruthes/DEV/ntexdb2/_dist/misc/pdf-quoting1.pdf
if [[ ! -e "$FRAME" ]]; then
    echo "Frame PDF does not exist. Supply a path using 'FRAME' environment variable."
    echo "Downloading default frame..."
    FRAME="$HOME/.cache/pdf-quoting1.pdf"
    wget "https://pub-714f8d634e8f451d9f2fe91a4debfa23.r2.dev/ntexdb2/8346e3ae7c49b159098d2eca/pdf-quoting1.pdf" -O "$FRAME" || exit 1
fi

input_pdf="$1"
output_pdf="$2"

[[ -z "$output_pdf" ]] && output_pdf="${input_pdf//.pdf/.quote.pdf}"

if ! command -v cpdf; then
    echo "Missing 'cpdf' dependency!"
    exit 1
fi



cpdf -scale-contents 0.85 -right 0mm "$input_pdf" \
    AND -shift "-10mm $SHIFT_Y" AND -stamp-under "$FRAME" \
    AND -add-text "$REAL_FOOTER_LEFT" -font-size 9 -pos-left "$FOOTER_POS_LEFT" \
    AND -add-text "$REAL_FOOTER_RIGHT" -font-size 9 -pos-right "$FOOTER_POS_RIGHT" \
    -o "$output_pdf"

echo "$output_pdf"
realpath "$output_pdf"
