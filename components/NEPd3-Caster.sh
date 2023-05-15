if [[ "$(uname)" != "Linux" ]]; then
    echo "This component can only work on Linux!"
fi

function NEPd3-mount() {
    MOUNTOPTS="-o noatime"
    if [[ -e /dev/disk/by-partlabel/Pd3Pv1 ]]; then
        ### LS2: Another Linux Storage
        sudo cryptsetup open /dev/disk/by-partuuid/0a7edafe-53d3-41c7-ac05-ef8630f0c353 NEPd3_LS2 --key-file $HOME/.MyLuksKey
        sudo mount $MOUNTOPTS /dev/mapper/NEPd3_LS2 /mnt/NEPd3_Caster/LS

        # ----------------------------------------------
        # LVM parts are not skipped...
        # ### LS: Linux Storage
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv1 NEPd3Pv1 --key-file $HOME/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv2 NEPd3Pv2 --key-file $HOME/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv3 NEPd3Pv3 --key-file $HOME/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv4 NEPd3Pv4 --key-file $HOME/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv5 NEPd3Pv5 --key-file $HOME/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv6 NEPd3Pv6 --key-file $HOME/.MyLuksKey
        # sudo cryptsetup open /dev/disk/by-partlabel/Pd3Pv7 NEPd3Pv7 --key-file $HOME/.MyLuksKey
        # ### How to recongnize the LVM setup on a new machine
        # sudo pvscan
        # sudo vgscan
        # sudo lvscan
        # sudo lvchange -a y /dev/NEPd3Vg1/NEPd3Lv1
        # sudo lvdisplay
        # sudo mount $MOUNTOPTS /dev/NEPd3Vg1/NEPd3Lv1 /mnt/NEPd3_Caster/LS
        # ----------------------------------------------

        ### AOSC: NEPd3A Root
        sudo cryptsetup open /dev/disk/by-partlabel/NEPd3_AOSC NEPd3_AOSC --key-file /home/neruthes/.MyLuksKey
        sudo mount $MOUNTOPTS /dev/mapper/NEPd3_AOSC /mnt/NEPd3_Caster/AOSC

        ### Shared: FAT32
        sudo mount $MOUNTOPTS /dev/disk/by-partlabel/NEPd3_Shared /mnt/NEPd3_Caster/Shared

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
    sudo umount /mnt/NEPd3_Caster/*
    for i in NEPd3_LS2; do
        sudo cryptsetup close $i
    done
}
