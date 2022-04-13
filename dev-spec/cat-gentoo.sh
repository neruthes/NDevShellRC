### ----------------------------------------------------------------------------
### Portage
function fullupdate() {
    # alias fullupdate="sudo emerge --verbose --update --newuse --tree --complete-graph --ask=n --with-bdeps=y --autounmask-continue --keep-going @world"
    # alias fullupdate="sudo emerge --ask=n --autounmask-write --autounmask-backtrack=y --backtrack=999 -vuDN --tree --complete-graph --keep-going @world"
    sudo proxychains emerge --sync
    sudo eix-update
    sudo proxychains emerge --ask=n --autounmask-write --autounmask-backtrack=y --backtrack=999 -vuDN --tree --complete-graph --keep-going @world
    sudo emerge @preserved-rebuild
    sudo eclean-dist
    sudo eclean-pkg
}

### ----------------------------------------------------------------------------
### Kernel
function saveKernelConfig() {
    sudo cp -v /usr/src/linux/.config /usr/src/.kernel-config
}
function loadKernelConfig() {
    sudo cp -v /usr/src/.kernel-config /usr/src/linux/.config
}
function buildMyKernelNow() {
    cd /usr/src/linux
    loadKernelConfig
    sudo make oldconfig
    saveKernelConfig
    source /etc/portage/make.conf
    sudo make -j3 all
    sudo make modules_install
    sudo make install
    sudo emerge @module-rebuild --ask=n
    pregenkernel
    sudo genkernel initramfs
    sudo rm /boot/*.old
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo eclean-kernel -n 7
}
