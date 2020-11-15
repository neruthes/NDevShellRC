if [[ `uname` == Darwin ]]; then
    exit 1
fi

function NEPd3-mount() {
    lsblk
    echo "--------------------------"
    echo "Is it sda or sdb? (1 letter)"
    SDX="sda"
    read SDX
    echo "Getting sudo...."
    sudo printf ''

    sudo cryptsetup open /dev/sd${SDX}10 NEPd3Pv1 --key-file ~/.MyLuksKey
    sudo cryptsetup open /dev/sd${SDX}9 NEPd3Pv2 --key-file ~/.MyLuksKey
    sudo cryptsetup open /dev/sd${SDX}8 NEPd3Pv3 --key-file ~/.MyLuksKey
    sudo cryptsetup open /dev/sd${SDX}7 NEPd3Pv4 --key-file ~/.MyLuksKey
    sudo cryptsetup open /dev/sd${SDX}6 NEPd3Pv5 --key-file ~/.MyLuksKey
    sudo cryptsetup open /dev/sd${SDX}5 NEPd3Pv6 --key-file ~/.MyLuksKey
    sudo cryptsetup open /dev/sd${SDX}4 NEPd3Pv7 --key-file ~/.MyLuksKey

    sudo vgcreate NEPd3Vg1 /dev/mapper/NEPd3Pv{1,2,3,4,5,6,7}
    sudo lvcreate -l 100%FREE -n NEPd3Lv1 NEPd3Vg1
    sudo mount /dev/NEPd3Vg1/NEPd3Lv1 /mnt/NEPd3_Caster/LS

    sudo cryptsetup open /dev/sd${SDX}12 NEPd3p12 --key-file ~/.MyLuksKey
    sudo mount /dev/mapper/NEPd3p12 /mnt/NEPd3_Caster/AOSC

    sudo mount /dev/disk/by-partlabel/NEPd3_Win /mnt/NEPd3_Caster/Win
    sudo mount /dev/disk/by-partlabel/NEPd3_Shared /mnt/NEPd3_Caster/Shared
}

function NEPd3-umount() {
    lsblk
    echo "--------------------------"
    echo "Is it sda or sdb? (1 letter)"
    SDX="sda"
    read SDX
    echo "Getting sudo...."
    sudo printf ''

    sudo umount /mnt/NEPd3_Caster/{LS,Win,Shared,AOSC}

    sudo cryptsetup close /dev/sd${SDX}10
    sudo cryptsetup close /dev/sd${SDX}9
    sudo cryptsetup close /dev/sd${SDX}8
    sudo cryptsetup close /dev/sd${SDX}7
    sudo cryptsetup close /dev/sd${SDX}6
    sudo cryptsetup close /dev/sd${SDX}5
    sudo cryptsetup close /dev/sd${SDX}4

    sudo cryptsetup close /dev/mapper/NEPd3p12
}
