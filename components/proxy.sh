alias s5pon="export ALL_PROXY=socks5://10.104.22.2:8080 && export HTTP_PROXY=socks5://10.104.22.2:8080"
alias s5poff="unset ALL_PROXY; unset HTTP_PROXY"

function s5pserver() {
    LOCAL_PORT=$1
    daemonize $(which gost) -L=:$LOCAL_PORT
}
function tcprpserver() {
    LOCAL_PORT=$1
    REMOTE_ADDR=$2
    REMOTE_PORT=$3
    daemonize $(which gost) -L=tcp://:$LOCAL_PORT:/$REMOTE_ADDR:$REMOTE_PORT
}
