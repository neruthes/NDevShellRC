function typst__listdeps() {
    local files_list="(typst c --root . "$1" -f pdf /dev/null --deps - | jq .inputs | grep -v '^/')"
    echo "$files_list"
}
