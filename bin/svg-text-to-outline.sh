#!/bin/bash

# ===============================================
# SVG Text to Path Converter using Inkscape
# Author: Gemini
# Description: Converts text elements in an input SVG to vector paths
# and saves the result to a specified output file.
# ===============================================

INPUT_SVG="$1"
OUTPUT_SVG="$2"
INKSCAPE_CMD="inkscape"

# 1. Argument Validation
if [ -z "$INPUT_SVG" ] || [ -z "$OUTPUT_SVG" ]; then
    echo "Usage: $0 <input_svg_path> <output_svg_path>"
    echo "Example: $0 input.svg output_paths.svg"
    exit 1
fi

# 2. Dependency Check (Inkscape)
if ! command -v "$INKSCAPE_CMD" &> /dev/null
then
    echo "Error: The 'inkscape' command is not found."
    echo "Please install Inkscape to use this script."
    exit 1
fi

# 3. Execution using Inkscape actions
echo "Starting conversion..."
echo "Input: $INPUT_SVG"
echo "Output: $OUTPUT_SVG"

# The actions sequence:
# select-all: Selects all objects in the document.
# object-to-path: Converts selected objects (including text) to paths.
# export-filename:$OUTPUT_SVG: Defines the output file path.
# export-do: Executes the export.
# quit-inkscape: Closes Inkscape.
"$INKSCAPE_CMD" --actions="select-all;object-to-path;export-filename:$OUTPUT_SVG;export-do;quit-inkscape" "$INPUT_SVG"

# 4. Status Check
if [ $? -eq 0 ]; then
    echo "-----------------------------------------------------"
    echo "Success! Text converted to paths and saved to $OUTPUT_SVG"
    echo "-----------------------------------------------------"
else
    echo "-----------------------------------------------------"
    echo "Error during Inkscape execution. Check file paths and Inkscape output."
    echo "-----------------------------------------------------"
fi

exit 0
