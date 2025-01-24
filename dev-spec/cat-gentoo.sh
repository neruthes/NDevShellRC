### ----------------------------------------------------------------------------
### Misc
function pyvenv-init() {
    python -m venv "$HOME/.python-venv"
}
function pyvenv-activate() {
    source "$HOME/.python-venv/bin/activate"
}


### ----------------------------------------------------------------------------
### Portage
function fullupdate() {
    sudo emerge --sync
    sudo eix-update
    sudo -E emerge --ask=n --autounmask-write --autounmask-backtrack=y --newuse --update --verbose --tree --complete-graph --keep-going @world
    sudo emerge --ask=n @preserved-rebuild
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
    source /etc/portage/make.conf
    cd /usr/src/linux
    loadKernelConfig
    sudo make oldconfig
    saveKernelConfig
    sudo make -j4 all
    sudo make modules_install
    sudo make install
    sudo emerge @module-rebuild --ask=n
    pregenkernel
    sudo genkernel initramfs
    # sudo rm /boot/*.old 2>/dev/null
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    # sudo eclean-kernel -n 7
    KERNEL_LOCAL_VER="$(basename "$(dirname "$(realpath /usr/src/linux/.config)")")"
    KERNELCONFDIR="$DEV_HOME_DIR/NDevShellRC/dev-local/$HOSTNAME/kernel-config"
    cat /usr/src/linux/.config > "$KERNELCONFDIR/$KERNEL_LOCAL_VER"
}
