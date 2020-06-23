function dropbox-open() {
    encfs ~/.Dropbox_EncFS /mnt/Dropbox
}

function dropbox-free() {
    encfs -u /mnt/Dropbox
}
