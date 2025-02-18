#!/bin/bash

[[ -z $SSH_PORT ]] && SSH_PORT=22

rsync -avxzP --safe-links --keep-dirlinks --mkpath --update --zc=zstd -e "ssh -p $SSH_PORT" "$@"
