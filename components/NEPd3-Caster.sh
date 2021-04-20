if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!"
fi

function NEPd3-mount() {
    if [[ -e /dev/disk/by-partlabel/Pd3Pv1 ]]; then
        ### LS: Linux Storage
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv1 NEPd3Pv1 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv2 NEPd3Pv2 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv3 NEPd3Pv3 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv4 NEPd3Pv4 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv5 NEPd3Pv5 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv6 NEPd3Pv6 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv7 NEPd3Pv7 --key-file ~/.MyLuksKey

        sudo vgcreate NEPd3Vg1 /dev/mapper/NEPd3Pv{1,2,3,4,5,6,7}
        sudo lvcreate -l 100%FREE -n NEPd3Lv1 NEPd3Vg1
        sudo mount /dev/NEPd3Vg1/NEPd3Lv1 /mnt/NEPd3_Caster/LS

        ### AOSC: NEPd3A Root
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd3_AOSC NEPd3_AOSC --key-file /home/neruthes/.MyLuksKey
        sudo mount /dev/mapper/NEPd3_AOSC /mnt/NEPd3_Caster/AOSC

        ### Shared: FAT32
        sudo mount /dev/disk/by-partlabel/NEPd3_Shared /mnt/NEPd3_Caster/Shared

        ### Test Case
        if [[ -e /mnt/NEPd3_Caster/LS/.IAmMounted ]]; then
            echo "Successfully mounted NEPd3."
        else
            echo "Error: Failed mounting NEPd3; cannot find mount mark file."
        fi
    else
        echo "Error: Disk is not connected."
    fi
}

function NEPd3-umount() {
    sudo umount /mnt/NEPd3_Caster/{LS,Shared,AOSC}

    sudo cryptsetup close /dev/mapper/NEPd3Pv1
    sudo cryptsetup close /dev/mapper/NEPd3Pv2
    sudo cryptsetup close /dev/mapper/NEPd3Pv3
    sudo cryptsetup close /dev/mapper/NEPd3Pv4
    sudo cryptsetup close /dev/mapper/NEPd3Pv5
    sudo cryptsetup close /dev/mapper/NEPd3Pv6
    sudo cryptsetup close /dev/mapper/NEPd3Pv7

    sudo cryptsetup close /dev/mapper/NEPd3_AOSC
}
