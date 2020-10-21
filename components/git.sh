function gitsetremote() {
    git remote add origin "https://neruthes:$(pas p token.github.clipass-synced)@github.com/$1.git"
}
function gitclone() {
    git clone "https://neruthes:$(pas p token.github.clipass-synced)@github.com/$1.git"
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

case `uname` in
    Linux)
        alias u="git add .; git commit -m 'Regular update `date -Is`'; git push;"
        ;;
    Darwin)
        alias u="git add .; git commit -m 'Regular update `date`'; git push;"
        ;;
esac
