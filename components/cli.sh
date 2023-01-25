export EDITOR="$(which nano)"

function ps1gitbr() {
    if [[ -z "$(which git 2>/dev/null)" ]]; then
        return 0
    fi
    L_GBSC="$(git branch --show-current 2>/dev/null)"
    if [[ ! -z "$L_GBSC" ]]; then
        printf ":$L_GBSC"
    fi
}

HOSTNAME_MAP="NDLT6|Betelgeuse
NDLT6G|Betelgeuse-Gentoo
NDLT7|Sirius
NDLT7W|Sirius-WSL
Z420|Catten"
MATCHED="$(echo "$HOSTNAME_MAP" | grep "$HOSTNAME|" | head -n1)"
if [[ ! -z "$MATCHED" ]]; then
    ps1devnickname=" ($(echo "$MATCHED" | cut -d'|' -f2))"
else
    ps1devnickname=""
fi
unset HOSTNAME_MAP
unset MATCHED

function ps1getsymbol() {
    if [[ "$(whoami)" == "root" ]]; then
        printf "\e[38;5;196m#\e[0m"
    else
        printf -- "$"
    fi
}

if [[ -e /.isChroot ]]; then
    PS1PREFIX_CHROOT="(chroot) "
else
    PS1PREFIX_CHROOT=""
fi

export PS1='$(termtitle "$HOSTNAME $PWD")'"\n${PS1PREFIX_CHROOT}\e[38;5;118m\u\e[0m \h$ps1devnickname \`date +%T\` \e[38;5;81m\W\e[0m\`ps1gitbr\`\n\`ps1getsymbol\` "


function termtitle() {
    printf "\033]0;$*\007"
}

