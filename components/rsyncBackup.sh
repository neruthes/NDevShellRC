if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!" >/dev/stderr
    exit 1
fi


if [[ "$HOSTNAME" == "NDLT7" ]]; then
    function ndrsyncpush() {
        rsync -av --exclude={'*/.git','**/.git','*/*/.git','*/*/*/.git','.*'} \
            /home/neruthes/DOC/ \
            neruthes@10.0.233.126:/Users/Neruthes/Documents/
    }
    function ndrsyncpull() {
        rsync -av --exclude={'*/.git','**/.git','*/*/.git','*/*/*/.git','.*'} \
            neruthes@10.0.233.126:/Users/Neruthes/Music/GarageBand/ \
            /home/neruthes/AUD/GarageBand/
        rsync -av --exclude={'*/.git','**/.git','*/*/.git','*/*/*/.git','.*'} \
            neruthes@10.0.233.126:/Users/Neruthes/Documents/Design/ \
            /home/neruthes/DOC/Design/
    }
fi

