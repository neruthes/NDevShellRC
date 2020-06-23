function mountExtArcher() {
    lsblk
    echo "--------------------------"
    echo "Is it sda or sdb? (1 letter)"
    SDA_OR_SDB="sda"
    read SDA_OR_SDB
    echo "Getting sudo...."
    sudo echo ''
    sudo cryptsetup open /dev/sd$(echo $SDA_OR_SDB)1 NEPd2_Archer_LS
    sudo mount /dev/mapper/NEPd2_Archer_LS /mnt/NEPd2_Archer/Archer_LS
    #sudo mount /dev/sd$(echo $SDA_OR_SDB)2 /mnt/NEPd2_Archer/Archer_TM
    #sudo mount -t hfsplus -o force,rw /dev/sd$(echo $SDA_OR_SDB)3 /mnt/NEPd2_Archer/Archer_Mac
}

function umountExtArcher() {
    lsblk
    echo "--------------------------"
    echo "Is it sda or sdb? (1 letter)"
    SDA_OR_SDB="sda"
    read SDA_OR_SDB
    echo "Getting sudo...."
    sudo echo ''
    sudo umount /dev/mapper/NEPd2_Archer_LS
    sudo cryptsetup close NEPd2_Archer_LS
    #sudo umount /dev/sd$(echo $SDA_OR_SDB)2
    #sudo umount /dev/sd$(echo $SDA_OR_SDB)3
}
