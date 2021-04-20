if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!"
fi

function NEPd4-mount() {
    if [[ -e /dev/disk/by-partlabel/NEPd4_PV6 ]]; then
        # sudo cryptsetup luksFormat /dev/disk/by-partlabel/NEPd4_PV2 --key-file ~/.MyLuksKey
        # sudo vgcreate NEPd4Vg1 /dev/mapper/NEPd4_PV{6,5,4,3}
        ### LS: Linux Storage
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV6 NEPd4_PV6 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV5 NEPd4_PV5 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV4 NEPd4_PV4 --key-file ~/.MyLuksKey
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV3 NEPd4_PV3 --key-file ~/.MyLuksKey

        ### LVM
        sudo vgcreate NEPd4Vg1 /dev/mapper/NEPd4_PV{6,5,4,3}
        sudo lvcreate -l 100%FREE -n NEPd4Lv1 NEPd4Vg1
        sudo mount /dev/NEPd4Vg1/NEPd4Lv1 /mnt/NEPd4_Intel660p/LS

        sudo mount --rbind /mnt/NEPd4_Intel660p/LS/VirtHome/images /var/lib/libvirt/images

        ### Test Case
        if [[ -e /mnt/NEPd4_Intel660p/LS/.IAmMounted ]]; then
            echo "Successfully mounted NEPd3."
        else
            echo "Error: Failed mounting NEPd3; cannot find mount mark file."
        fi
    else
        echo "Error: Disk is not connected."
    fi
}

function NEPd4-umount() {
    sudo umount /var/lib/libvirt/images
    sudo umount /mnt/NEPd4_Intel660p/LS

    sudo cryptsetup close /dev/mapper/NEPd4_PV6
    sudo cryptsetup close /dev/mapper/NEPd4_PV5
    sudo cryptsetup close /dev/mapper/NEPd4_PV4
    sudo cryptsetup close /dev/mapper/NEPd4_PV3
}
