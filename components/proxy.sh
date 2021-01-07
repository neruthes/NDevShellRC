#alias s5pon="export ALL_PROXY=socks5://10.104.22.2:8080 && export HTTP_PROXY=socks5://10.104.22.2:8080"
#alias s5poff="unset ALL_PROXY; unset HTTP_PROXY"

function s5pon() {
    for i in ALL_PROXY HTTP_PROXY HTTPS_PROXY http_proxy https_proxy; do
        export $i=socks5://10.104.22.2:8080
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
