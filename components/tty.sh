# TTY Personalization
if [[ `tty` =~ "/dev/tty" ]]; then
    echo "Using font Uni2-TerminusBold20x10"
    setfont Uni2-TerminusBold20x10
fi
