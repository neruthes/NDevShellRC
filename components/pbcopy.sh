if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!"
    exit 1
fi

## Basics
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'