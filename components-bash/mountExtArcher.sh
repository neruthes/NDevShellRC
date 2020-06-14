function mountExtArcher() {
    sudo cryptsetup open /dev/sda1 NEPd2_Archer_LS
    sudo mount /dev/mapper/NEPd2_Archer_LS /mnt/NEPd2_Archer/Archer_LS
    sudo mount /dev/sda2 /mnt/NEPd2_Archer/Archer_TM
    sudo mount /dev/sda3 /mnt/NEPd2_Archer/Archer_Mac
}
