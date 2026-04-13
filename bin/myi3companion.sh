#!/bin/bash

# NOTE:
#       mkdir -p ~/.local/share/python-venv/
#       python3 -m venv ~/.local/share/python-venv/i3wm.venv

source ~/.local/share/python-venv/i3wm.venv/bin/activate

pypath="$DEV_HOME_DIR/NDevShellRC/bin/myi3companion.py"  ### See https://github.com/neruthes/NDevShellRC/blob/master/bin/myi3companion.py

python3 "$pypath"