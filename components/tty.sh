# Shell Personalization.
if [[ `tty` =~ "/dev/tty" ]]; then
    echo "setfont latarcyrheb-sun32"
    setfont latarcyrheb-sun32
fi
