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

    pdf_quote_frame.sh  in.pdf  out.pdf  [options]


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

    LEFT_FOOTER_PREFIX
    RIGHT_FOOTER_SUFFIX     Slightly prefix/suffix the footers.

    INCLUDE_RAW_PDF=y       Include input raw PDF as attachment.
    -r, --raw

    SHOW_PDF_PATH=y         Include PDF path in right footer.
    -p, --path

    SHOW_PDF_HASH=y         Include PDF SHA-1 hash in left footer.
    --hash

    EXTRA_FOOTER_LEFT
    EXTRA_FOOTER_RIGHT      Extra static string to append/prepend the left/right footer.

    FOOTER_POS_LEFT
    FOOTER_POS_RIGHT        Override the position of the left/right footer.

    SHIFT_X=-10mm
    SHIFT_Y=-10mm           Define custom offsets.

"
    exit 0      ### After showing USAGE guide, do nothing and exit
}



### Initialize default values
input_pdf="$1"
output_pdf="$2"
[[ -z "$output_pdf" ]] && output_pdf="${input_pdf//.pdf/.quote.pdf}"

[[ -z "$SHOW_PDF_PATH" ]] && SHOW_PDF_PATH="n"
# DEFAULT_FOOTER_LEFT="%Y/%b/%d %a %T"
DEFAULT_FOOTER_LEFT="${LEFT_FOOTER_PREFIX}%Y/%b/%d %a"
DEFAULT_FOOTER_RIGHT="Page %Page of %EndPage${RIGHT_FOOTER_SUFFIX}"
HASH_PLACEHOLDER='b9d0683e937a'
HASH_FORMAT='(SHA-1 hash: b9d0683e937a)'
[[ -z "$SHIFT_X" ]] && SHIFT_X="-10mm"
[[ -z "$SHIFT_Y" ]] && SHIFT_Y="-9.3mm"

### Parse argv to override default values
_cached_argv="$*"
function check_substr_argv() {
    [[ " $_cached_argv " == *"$1"* ]] && return 0 || return 1
}
check_substr_argv ' -h ' || check_substr_argv ' --help ' && _show_help
check_substr_argv ' -r ' || check_substr_argv ' --raw ' && INCLUDE_RAW_PDF=y
check_substr_argv ' -p ' || check_substr_argv ' --path ' && SHOW_PDF_PATH=y
check_substr_argv ' --hash ' && SHOW_PDF_HASH=y

[[ -z "$1" ]] && _show_help




for envfn in "$HOME/.config/pdf_quote_frame.sh.env" .env; do
    [[ -e "$envfn" ]] && source "$envfn"
done




hashfn="$input_pdf".hash.txt
sha1sum "$input_pdf" > "$hashfn"
hash_value="$(cut -c1-40 < "$hashfn")"

### Overwrite supplied vars
formated_hash_string="$(echo "${HASH_FORMAT/$HASH_PLACEHOLDER/$hash_value}" )"
[[ "$SHOW_PDF_HASH" == y ]] && DEFAULT_FOOTER_LEFT="$DEFAULT_FOOTER_LEFT    $formated_hash_string"
[[ "$SHOW_PDF_PATH" == y ]] && DEFAULT_FOOTER_RIGHT="$(basename "$1")    $DEFAULT_FOOTER_RIGHT"
[[ -z "$REAL_FOOTER_LEFT" ]] && REAL_FOOTER_LEFT="$DEFAULT_FOOTER_LEFT $EXTRA_FOOTER_LEFT"
[[ -z "$REAL_FOOTER_RIGHT" ]] && REAL_FOOTER_RIGHT="$EXTRA_FOOTER_RIGHT $DEFAULT_FOOTER_RIGHT"
[[ -z "$FOOTER_POS_LEFT" ]] && FOOTER_POS_LEFT="21.1mm 10mm"
[[ -z "$FOOTER_POS_RIGHT" ]] && FOOTER_POS_RIGHT="200mm 10mm"




[[ -z "$FRAME" ]] && FRAME=/home/neruthes/DEV/ntexdb2/_dist/misc/pdf-quoting1.pdf
if [[ ! -e "$FRAME" ]]; then
    echo "Frame PDF does not exist. Supply a path using 'FRAME' environment variable."
    echo "Downloading default frame..."
    FRAME="$HOME/.cache/pdf-quoting1.pdf"
    wget "https://pub-714f8d634e8f451d9f2fe91a4debfa23.r2.dev/ntexdb2/8346e3ae7c49b159098d2eca/pdf-quoting1.pdf" -O "$FRAME" || exit 1
fi



if ! command -v cpdf; then
    echo "Missing 'cpdf' dependency!"
    exit 1
fi






# Main job here!
cpdf -scale-contents 0.85 -right 0mm "$input_pdf" \
    AND -shift "$SHIFT_X $SHIFT_Y" AND -stamp-under "$FRAME" \
    AND -add-text "$REAL_FOOTER_LEFT" -font-size 9 -pos-left "$FOOTER_POS_LEFT" \
    AND -add-text "$REAL_FOOTER_RIGHT" -font-size 9 -pos-right "$FOOTER_POS_RIGHT" \
    -o "$output_pdf"





if [[ "$INCLUDE_RAW_PDF" == y ]]; then
    tmppdf="$output_pdf.tmp_attachment.pdf"
    function _mv_from_tmp() {
        mv -f "$tmppdf" "$output_pdf"
    }
    pdftk "$output_pdf" attach_files "$input_pdf" output "$tmppdf"
    _mv_from_tmp
    pdftk "$output_pdf" attach_files "$hashfn" output "$tmppdf"
    _mv_from_tmp
fi

rm "$hashfn"




# Before we really exit...
echo "$output_pdf"
realpath "$output_pdf"
