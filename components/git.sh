function gitsetremote() {
    git remote add origin "https://neruthes:$(pasm p token.github.clipass-synced)@github.com/$1.git"
}
function gitclone() {
    git clone "https://neruthes:$(pasm p token.github.clipass-synced)@github.com/$1.git"
}
function gcl() {
    SERVICE="$1"
    REPOID="$2"
    RHOST=""
    case "$SERVICE" in
        gh)
            RHOST="github.com"
            ;;
        stn)
            RHOST="git.shinonometn.com"
            ;;
        *)
            echo "ERROR: Unknown service provider"
            return 1
            ;;
    esac
    git clone git@$RHOST:$REPOID.git
}
function gitnuke() {
    cp .git/config .gitconf
    rm -rf .git
    git init
    cat .gitconf > .git/config
    rm .gitconf
    git add .
    git commit -m "GITNUKE"
    echo "Git history nuked"
}

unalias g &> /dev/null
function g() {
    git add .
    git commit -m "$1"
    git push
}

alias gpom="git push origin master"
alias gpuom="git push -u origin master"

case `uname` in
    Linux)
        alias u="git add .; git commit -m 'Regular update `date -Is`'; git push;"
        ;;
    Darwin)
        alias u="git add .; git commit -m 'Regular update `date`'; git push;"
        ;;
esac
