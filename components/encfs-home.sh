function encfs-myhome-mount() {
    NDevVar set syslock-encfs-myhome-mount LOCKED--$USER
    encfs --reversewrite /home/neruthes/DES /mnt/EncFS-home-neruthes/DES
    encfs --reversewrite /home/neruthes/DEV /mnt/EncFS-home-neruthes/DEV
    encfs --reversewrite /home/neruthes/DOC /mnt/EncFS-home-neruthes/DOC
    encfs --reversewrite /home/neruthes/PIC /mnt/EncFS-home-neruthes/PIC
    encfs --reversewrite /home/neruthes/AUD /mnt/EncFS-home-neruthes/AUD
    encfs --reversewrite /home/neruthes/VID /mnt/EncFS-home-neruthes/VID
}

function encfs-myhome-unmount() {
    encfs -u /mnt/EncFS-home-neruthes/DES
    encfs -u /mnt/EncFS-home-neruthes/DEV
    encfs -u /mnt/EncFS-home-neruthes/DOC
    encfs -u /mnt/EncFS-home-neruthes/PIC
    encfs -u /mnt/EncFS-home-neruthes/AUD
    encfs -u /mnt/EncFS-home-neruthes/VID
    NDevVar del syslock-encfs-myhome-mount
}

function encfs-myhome-rclone-backup-dropbox() {
    # $1: Directory Name
    rclone sync -P -L /mnt/EncFS-home-neruthes/$1 Dropbox-Neruthes:EncFS-Home.$1
}
