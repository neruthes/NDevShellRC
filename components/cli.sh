# export EDITOR="$(which nano)"

function ps1gitbr() {
    git branch --show-current > /tmp/.L_GBSC_$USER 2>&1
    # git rev-parse --abbrev-ref HEAD > /tmp/.L_GBSC_$USER 2>&1
    L_GBSC=$(cat /tmp/.L_GBSC_$USER)
#    echo "$L_GBSC"
    if [[ ${L_GBSC::5} == 'fatal' ]]; then
        printf ""
    else
        printf ":$L_GBSC"
    fi
}

function ps1devnickname() {
    case `hostname` in
        NDVS*)
            printf -- ' (VPS)'
            ;;
        NDLT6)
            printf -- ' (Betelgeuse)'
            ;;
        NDLT7)
            printf -- ' (Sirius)'
            ;;
        NDLT7W)
            printf -- ' (Sirius-WSL)'
            ;;
        NEPd2U)
            printf -- ' (Archer-Ubuntu)'
            ;;
    esac
}

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

export PS1="\n${PS1PREFIX_CHROOT}\e[38;5;118m\u\e[0m \h`ps1devnickname` \e[38;5;81m\W\e[0m\`ps1gitbr\` \`ps1getsymbol\` "


### I no longer use Gentoo Prefix
# function iamusinggentooprefix() {
#     export PS1="(Gentoo Prefix) ${PS1:0}"
# }
