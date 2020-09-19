function dropbox-open() {
    encfs ~/.Dropbox_EncFS /mnt/Dropbox
}

function dropbox-free() {
    encfs -u /mnt/Dropbox
}

function dropbox-home-backup() {
    #rsync -av /home/neruthes/DEV /mnt/Dropbox/NDLT7-backup-home/
    #rsync -av /home/neruthes/DOC /mnt/Dropbox/NDLT7-backup-home/
    #rsync -av /home/neruthes/AUD /mnt/Dropbox/NDLT7-backup-home/
    rsync -av /home/neruthes/{DEV,DOC,AUD} /mnt/Dropbox/NDLT7-backup-home/ --delete
}
