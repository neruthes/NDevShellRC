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
function gitbranchshowcurrent() {
    MYGB="gitbranchshowcurrent--mygb"
    L_GBSC="`git branch --show-current 2> /tmp/GBSC & cat /tmp/GBSC`"
    rm /tmp/GBSC
#    echo "$L_GBSC"
    if [[ ${L_GBSC::5} == 'fatal' ]]; then
#        echo 'Fatal detected'
#        printf ""
        touch /tmp/GBSC
        rm /tmp/GBSC
    else
        printf ":$L_GBSC"
    fi
}

unalias g &> /dev/null
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
