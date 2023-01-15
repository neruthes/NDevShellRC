function gitsetremote() {
    git remote add origin "https://neruthes:$(pasm p token.github.major)@github.com/$1.git"
}
function gitclone() {
    git clone "https://neruthes:$(pasm p token.github.major)@github.com/$1.git"
}
function gitnuke() {
    cp .git/config gitconfig
    rm -rf .git
    git init
    cat gitconfig > .git/config
    rm gitconfig
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

function u() {
    case "$(uname)" in
        Linux)
            DATESTR="$(date -Is)"
            ;;
        Darwin)
            DATESTR="$(date)"
            ;;
    esac
    git add .
    git commit -m "Regular update '$DATESTR'"
    git push
}

