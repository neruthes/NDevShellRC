if [[ "$(uname)" != "Linux" ]]; then
    echo "This component can only work on Linux!"
fi

## Basics
alias pbcopy='xclip -selection clipboard'
alias pbcopy_tr='tr -d "\n" | xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
