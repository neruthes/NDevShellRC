if [[ "$(uname)" != "Linux" ]]; then
    echo "This component can only work on Linux!"
fi

## Basics
alias pbcopy='tr -d "\n" | xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
