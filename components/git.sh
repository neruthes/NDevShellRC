function gitclone() {
    git clone "https://neruthes:$(pas p token.github.ndlt7-sirius)@github.com/$1.git"
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

unalias g
function g() {
    git add .
    git commit -m "$1"
    git push
}

if [[ $NDEV_OS_TYPE == 'linux' ]]; then
    alias u="git add .; git commit -m 'Regular update `date -Is`'; git push;"
fi

if [[ $NDEV_OS_TYPE == 'macosx' ]]; then
    alias u="git add .; git commit -m 'Regular update `date`'; git push;"
fi
