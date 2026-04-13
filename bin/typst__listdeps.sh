#!/bin/bash

typst c --root . "$1" -f pdf /dev/null --deps - | jq -r '.inputs[]' | grep -v '^/'