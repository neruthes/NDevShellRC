function encfs-myhome-mount() {
    encfs --reversewrite /home/neruthes/DES /mnt/Syncthing-EncFS-Neruthes/home/DES
    encfs --reversewrite /home/neruthes/DEV /mnt/Syncthing-EncFS-Neruthes/home/DEV
    encfs --reversewrite /home/neruthes/DOC /mnt/Syncthing-EncFS-Neruthes/home/DOC
    encfs --reversewrite /home/neruthes/PIC /mnt/Syncthing-EncFS-Neruthes/home/PIC
    encfs --reversewrite /home/neruthes/AUD /mnt/Syncthing-EncFS-Neruthes/home/AUD
    encfs --reversewrite /home/neruthes/VID /mnt/Syncthing-EncFS-Neruthes/home/VID
    encfs --reversewrite /home/neruthes/NET /mnt/Syncthing-EncFS-Neruthes/home/NET
    encfs --reversewrite /home/neruthes/EWS /mnt/Syncthing-EncFS-Neruthes/home/EWS
}

function encfs-myhome-unmount() {
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/DES
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/DEV
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/DOC
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/PIC
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/AUD
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/VID
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/NET
    encfs -u /mnt/Syncthing-EncFS-Neruthes/home/EWS
}
