#!/bin/bash

pdftk "$1" attach_files "$2" output "$1.tmp_attachment.pdf"
mv "$1.tmp_attachment.pdf" "$1"
