#!/bin/bash

gs \
 -sOutputFile="$1.tmp" \
 -sDEVICE=pdfwrite \
 -sColorConversionStrategy=Gray \
 -dProcessColorModel=/DeviceGray \
 -dCompatibilityLevel=1.4 \
 -dNOPAUSE \
 -dBATCH \
 "$1"
mv "$1.tmp" "$1"
