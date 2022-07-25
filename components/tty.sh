# TTY Personalization
# if [[ `tty` =~ "/dev/tty" ]]; then
#     echo "Using font Uni2-TerminusBold20x10"
#     setfont Uni2-TerminusBold20x10
# fi

if [[ $(tty) == "/dev/tty"* ]]; then
    sudo setfont latarcyrheb-sun32
fi
