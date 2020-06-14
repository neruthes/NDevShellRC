function gitclone() {
    git clone "https://neruthes:$(pas p token.github.ndlt7-sirius)@github.com/$1.git"
}
function gitnuke() {
    cp .git/config .gitconf
    rm -rf .git
    git init
    cat .gitconf > .git/config
    git add .
    git commit -m "GITNUKE"
    rm .gitconf
    echo "Git history nuked"
}
alias u="git add .; git commit -m 'Regular update `date -Is`'; git push;"
alias g="git add .; git commit -m '$1'; git push;"
