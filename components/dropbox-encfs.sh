function dropbox-open() {
    encfs ~/.Dropbox_EncFS /mnt/Dropbox
}

function dropbox-free() {
    encfs -u /mnt/Dropbox
}

function dropbox-home-backup() {
    cp -R /home/neruthes/DEV/* /mnt/Dropbox/NDLT7-backup-home/DEV/
    cp -R /home/neruthes/DOC/* /mnt/Dropbox/NDLT7-backup-home/DOC/
    cp -R /home/neruthes/AUD/* /mnt/Dropbox/NDLT7-backup-home/AUD/
}
