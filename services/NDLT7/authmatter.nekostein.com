function start() {
    daemonize -p "$PIDFILE" -o "$LOGFILE" -e "$LOGFILE" -- /bin/bash /home/neruthes/DEV/authmatter-node/sites-enabled/nekostein.sh
}
function stop() {
    start-stop-daemon --stop --pidfile "$PIDFILE" --user "$USER" --verbose
}
function restart() {
    stop
    start
}
