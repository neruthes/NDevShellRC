if [[ "$(uname)" != "Linux" ]]; then
    echo "This script can only work on Linux!"
    exit 1
fi

function NEPd2-mount() {
    if [[ -e /dev/disk/by-partlabel/NEPd2_Data ]]; then
        ### LS: Linux Storage
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd2_Data NEPd2_Data
        sudo mount /dev/mapper/NEPd2_Data /mnt/NEPd2_Archer/LS

        ### Unencrypted filesystems
        sudo mount /dev/disk/by-partlabel/NEPd2_ESP /mnt/NEPd2_Archer/ESP
        sudo mount /dev/disk/by-partlabel/NEPd2_usr /mnt/NEPd2_Archer/usr

        ### Test Case
        if [[ -e /mnt/NEPd2_Archer/LS/.IAmMounted ]]; then
            echo "Successfully mounted NEPd2."
        else
            echo "Error: Failed mounting NEPd2; cannot find mount mark file."
        fi
    else
        echo "Error: Disk is not connected."
    fi
}

function NEPd2-umount() {
    sudo umount /mnt/NEPd2_Archer/{ESP,LS,usr}

    sudo cryptsetup close /dev/mapper/NEPd2Pv1
}
