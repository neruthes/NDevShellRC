if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!"
fi

function NEPd4-mount() {
    MOUNTOPTS="-o noatime"
    if [[ -e /dev/disk/by-partlabel/NEPd4_PV6 ]]; then
        # sudo cryptsetup luksFormat /dev/disk/by-partlabel/NEPd4_PV2 --key-file ~/.MyLuksKey
        # sudo vgcreate NEPd4Vg1 /dev/mapper/NEPd4_PV{6,5,4,3}
        ### LS: Linux Storage
        for i in 1 2 3 4 5 6; do
            sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV$i NEPd4_PV$i --key-file ~/.MyLuksKey
        done
        # sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV6 NEPd4_PV6 --key-file ~/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV5 NEPd4_PV5 --key-file ~/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV4 NEPd4_PV4 --key-file ~/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV3 NEPd4_PV3 --key-file ~/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV2 NEPd4_PV2 --key-file ~/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/NEPd4_PV1 NEPd4_PV1 --key-file ~/.MyLuksKey

        ### LVM
        sudo vgcreate NEPd4Vg1 /dev/mapper/NEPd4_PV{6,5,4,3,2,1}
        sudo lvcreate -l 100%FREE -n NEPd4Lv1 NEPd4Vg1
        sudo mount $MOUNTOPTS /dev/NEPd4Vg1/NEPd4Lv1 /mnt/NEPd4_Intel660p/LS

        ### NTFS
        sudo mount $MOUNTOPTS /dev/disk/by-partuuid/723ce7d8-07ea-4b99-b361-2eba66ff8467 /mnt/NEPd4_Intel660p/NTFS

        ### Test Case
        if [[ -e /mnt/NEPd4_Intel660p/LS/.IAmMounted ]]; then
            echo "Successfully mounted NEPd4."
        else
            echo "Error: Failed mounting NEPd4; cannot find mount mark file."
        fi
    else
        echo "Error: Disk is not connected."
    fi
}

function NEPd4-umount() {
    sudo umount /var/lib/libvirt/images
    sudo umount /mnt/NEPd4_Intel660p/LS

    # sudo vgremove NEPd4Vg1

    # sudo cryptsetup close /dev/mapper/NEPd4_PV6
    # sudo cryptsetup close /dev/mapper/NEPd4_PV5
    # sudo cryptsetup close /dev/mapper/NEPd4_PV4
    # sudo cryptsetup close /dev/mapper/NEPd4_PV3
    # sudo cryptsetup close /dev/mapper/NEPd4_PV2
    # sudo cryptsetup close /dev/mapper/NEPd4_PV1
}
