function ps1gitbr() {
    git branch --show-current > /tmp/L_GBSC_`whoami` 2>&1
    L_GBSC=`cat /tmp/L_GBSC_$(whoami)`
#    echo "$L_GBSC"
    if [[ ${L_GBSC::5} == 'fatal' ]]; then
#        echo 'Fatal detected'
#        rm /tmp/L_GBSC
        printf ""
    else
        printf ":$L_GBSC"
#        rm /tmp/L_GBSC
    fi
}

function ps1devnickname() {
    case `hostname` in
        NDLT6)
            printf -
            printf Betelgeuse
            ;;
        NDLT7)
            printf -
            printf Sirius
            ;;
        NDLT7W)
            printf -
            printf Sirius-Windows
            ;;
        NEPd2U)
            printf -
            printf Archer-Ubuntu
            ;;
    esac
}

function ps1getsymbol() {
    if [[ `whoami` == 'root' ]]; then
        printf "\e[38;5;196m#\e[0m"
    else
        printf "$"
    fi
}

export PS1="\n\e[38;5;118m\u\e[0m \h`ps1devnickname` \e[38;5;81m\W\e[0m\`ps1gitbr\` \`ps1getsymbol\` "
