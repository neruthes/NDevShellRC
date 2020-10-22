if [[ `uname` == Darwin ]]; then
    exit 1
fi

function mountExtArcher() {
    lsblk
    echo "--------------------------"
    echo "Is it sda or sdb? (1 letter)"
    SDX="sda"
    read SDX
    echo "Getting sudo...."
    sudo printf ''
    sudo cryptsetup open /dev/sd${SDX}1 NEPd2_Archer_LS
    sudo mount /dev/mapper/NEPd2_Archer_LS /mnt/NEPd2_Archer/Archer_LS
    sudo mount /dev/sd${SDX}2 /mnt/NEPd2_Archer/Archer_TM
    sudo mount -t hfsplus -o force,rw /dev/sd${SDX}3 /mnt/NEPd2_Archer/Archer_Mac
    sudo mount /dev/sd${SDX}5 /mnt/NEPd2_Archer/Archer_ElementaryOS
    sudo mount /dev/sd${SDX}6 /mnt/NEPd2_Archer/Archer_ESP
    sudo mount /dev/sd${SDX}7 /mnt/NEPd2_Archer/Archer_Ubuntu
}

function umountExtArcher() {
    lsblk
    echo "--------------------------"
    echo "Is it sda or sdb? (1 letter)"
    SDX="sda"
    read SDX
    echo "Getting sudo...."
    sudo printf ''
    sudo umount /dev/mapper/NEPd2_Archer_LS
    sudo cryptsetup close NEPd2_Archer_LS
    sudo umount /dev/sd${SDX}2
    sudo umount /dev/sd${SDX}3
    sudo umount /dev/sd${SDX}5
    sudo umount /dev/sd${SDX}6
    sudo umount /dev/sd${SDX}7
}
