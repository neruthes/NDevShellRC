#!/bin/bash

remote_repo_path="$1"
[[ -z "$remote_repo_path" ]] && remote_repo_path="$USER/$(basename "$PWD")"

if git remote | grep -sq '^nsdev$'; then
    git push nsdev
else
    ssh git@git.nekostein.com "mkdir -p '$remote_repo_path' && cd '$remote_repo_path' && git init"
    sleep 1
    git remote add nsdev "git@git.nekostein.com:$remote_repo_path" && git push nsdev
    sleep 1
fi
