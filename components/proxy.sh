#alias s5pon="export ALL_PROXY=socks5://10.104.22.2:8080 && export HTTP_PROXY=socks5://10.104.22.2:8080"
#alias s5poff="unset ALL_PROXY; unset HTTP_PROXY"

function s5pon() {
    PROXY_TINC=socks5://10.104.22.2:8080
    PROXY_LAN=socks5://192.168.1.20:1082

    if [[ "$(ip addr | grep 192.168.31)" == "" ]]; then
        MY_PROXY_CHOICE=$PROXY_TINC
    else
        MY_PROXY_CHOICE=$PROXY_LAN
    fi
    
    for i in ALL_PROXY HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
        export $i=$MY_PROXY_CHOICE
    done
}

function s5poff() {
    for i in ALL_PROXY HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
        unset $i
    done
}

function s5pserver() {
    LOCAL_PORT=$1
    USER_PASSWD=$2
    if [[ "x$USER_PASSWD" != "x" ]]; then
        daemonize "$(which gost)" -L=$USER_PASSWD@localhost:$LOCAL_PORT
    else
        daemonize "$(which gost)" -L=:$LOCAL_PORT
    fi
    echo "Created SOCKS5 proxy at 'localhost:$LOCAL_PORT'"
}
function tcprpserver() {
    LOCAL_PORT=$1
    REMOTE_ADDR=$2
    REMOTE_PORT=$3
    daemonize "$(which gost)" -L=tcp://:$LOCAL_PORT/$REMOTE_ADDR:$REMOTE_PORT
    echo "Proxying 'localhost:$LOCAL_PORT' -> '$REMOTE_ADDR:$REMOTE_PORT'"
}
