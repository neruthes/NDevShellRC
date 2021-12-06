if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!"
fi

function NEPd4-mount() {
    MOUNTOPTS="-o noatime"
    if [[ -e /dev/disk/by-partlabel/NEPd4_LS ]]; then
        sudo cryptsetup open /dev/nvme0n1p4 NEPd4_LS --key-file ~/.MyLuksKey
        sudo mount $MOUNTOPTS /dev/mapper/NEPd4_LS /mnt/NEPd4_Intel660p/LS

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
    sudo cryptsetup close NEPd4_LS

}
