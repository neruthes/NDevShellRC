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
