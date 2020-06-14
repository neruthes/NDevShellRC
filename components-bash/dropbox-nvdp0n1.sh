function nvdp0n1-vdisk-s1-map() {
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p1.bin nvdp0n1p1 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p2.bin nvdp0n1p2 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p3.bin nvdp0n1p3 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p4.bin nvdp0n1p4 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    # ---
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p5.bin nvdp0n1p5 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p6.bin nvdp0n1p6 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p7.bin nvdp0n1p7 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p8.bin nvdp0n1p8 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p9.bin nvdp0n1p9 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p10.bin nvdp0n1p10 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p11.bin nvdp0n1p11 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    sudo cryptsetup open ~/.Dropbox_Encrypted/nvdp0n1p12.bin nvdp0n1p12 --key-file ~/.Dropbox_LUKS_Keyfile.bin
    # ---
    # Current top: 12
}
function nvdp0n1-vdisk-s3-combine() {
    vgcreate nvdp0n1x /dev/mapper/nvdp0n1p1 /dev/mapper/nvdp0n1p2 /dev/mapper/nvdp0n1p3 /dev/mapper/nvdp0n1p4 /dev/mapper/nvdp0n1p5 /dev/mapper/nvdp0n1p6 /dev/mapper/nvdp0n1p7 /dev/mapper/nvdp0n1p8 /dev/mapper/nvdp0n1p9 /dev/mapper/nvdp0n1p10
    sudo lvcreate -L 768M nvdp0n1x -n nvdp0n1z
    sudo vgchange -a y nvdp0n1x
}
function nvdp0n1-vdisk-s4-mkfs() {
    #sudo mkfs.ext2 /dev/mapper/nvdp0n1x-nvdp0n1z // Already done
}
function nvdp0n1-vdisk-add-extra-block() {
    # 82 MB = Data (64 MB) + LUKS Header (16 MB) + Extra Allowance (2 MB)
    dd if=/dev/urandom of=~/.Dropbox_Encrypted/nvdp0n1p$1.bin bs=82M count=1 iflag=fullblock
    cryptsetup luksFormat ~/.Dropbox_Encrypted/nvdp0n1p$1.bin ~/.Dropbox_LUKS_Keyfile.bin
}
function nvdp0n1-mount() {
    nvdp0n1-vdisk-s1-map()
    nvdp0n1-vdisk-s3-combine()
    sudo mount /dev/mapper/nvdp0n1x-nvdp0n1z ~/mnt/Dropbox
}
