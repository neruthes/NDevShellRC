#!/bin/bash

#########################################################################################
# The 'pdf_quote_frame.sh' script
#
# Copyright 2025 Neruthes (https://neruthes.xyz) (https://github.com/neruthes).
# Published with the MIT license (https://mit-license.org/).
#########################################################################################


function _show_help() {
    echo "pdf_quote_frame.sh

Copyright 2025 Neruthes (https://neruthes.xyz) (https://github.com/neruthes).
Published with the MIT license (https://mit-license.org/).

USAGE:

    pdf_quote_frame.sh in.pdf out.pdf


CONFIG:

    This program reads config from the following locations:

    1)  \$HOME/.config/pdf_quote_frame.sh.env
    2)  \$PWD/.env

    You can set env in these files instead of supplying env variables to the script.
    Buf if you do, env variables override the configs.


ENVIRONMENT VARIABLES:

    FRAME                   Path to frame PDF. If no frame is available, this program
                                will try downloading a default one from the web.

    DEFAULT_FOOTER_LEFT
    DEFAULT_FOOTER_RIGHT    The default footer text. See cpdf manual for formatting.

    SHOW_PDF_PATH=y         Include PDF path in right footer.

    EXTRA_FOOTER_LEFT
    EXTRA_FOOTER_RIGHT      Extra static string to append/prepend the left/right footer.

    FOOTER_POS_LEFT
    FOOTER_POS_RIGHT        Override the position of the left/right footer.

    SHIFT_X=-10mm
    SHIFT_Y=-10mm           Define custom offsets.

"
    exit 0
}
case " $* " in
    *' -h '* | *' --help '* ) _show_help ;;
esac
[[ -z "$1" ]] && _show_help



### Initialize default values
SHOW_PDF_PATH="n"
DEFAULT_FOOTER_LEFT="%Y/%b/%d %a %T"
DEFAULT_FOOTER_RIGHT="Page %Page of %EndPage"
SHIFT_X="-10mm"
SHIFT_Y="-9.3mm"


[[ -e "$HOME/.config/pdf_quote_frame.sh.env" ]] && source "$HOME/.config/pdf_quote_frame.sh.env"
[[ -e ".env" ]] && source ".env"


### Overwrite supplied vars
[[ "$SHOW_PDF_PATH" == y ]] && DEFAULT_FOOTER_RIGHT="$(basename "$1")         $DEFAULT_FOOTER_RIGHT"
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
    AND -shift "$SHIFT_X $SHIFT_Y" AND -stamp-under "$FRAME" \
    AND -add-text "$REAL_FOOTER_LEFT" -font-size 9 -pos-left "$FOOTER_POS_LEFT" \
    AND -add-text "$REAL_FOOTER_RIGHT" -font-size 9 -pos-right "$FOOTER_POS_RIGHT" \
    -o "$output_pdf"

echo "$output_pdf"
realpath "$output_pdf"
