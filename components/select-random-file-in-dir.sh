function select-random-file-in-dir() {
    ll $1 > /tmp/select-random-file-in-dir__ll.txt
    node $DEV_HOME_DIR/NDevShellRC/components/nodejs/select-random-file-in-dir.js $1
    #rm /tmp/select-random-file-in-dir__ls.txt
}

# select-random-file-in-dir ~/PIC/My_Wallpapers
