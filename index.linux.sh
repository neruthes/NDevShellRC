# PATH
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh

# Drives
source $DEV_HOME_DIR/NDevShellRC/components/NEPd2-Archer.sh
source $DEV_HOME_DIR/NDevShellRC/components/NEPd3-Caster.sh
source $DEV_HOME_DIR/NDevShellRC/components/borgBackup.sh
source $DEV_HOME_DIR/NDevShellRC/components/rsyncBackup.sh

# Network
source $DEV_HOME_DIR/NDevShellRC/components/proxy.sh

# Terminal Hacks
source $DEV_HOME_DIR/NDevShellRC/components/tty.sh
source $DEV_HOME_DIR/NDevShellRC/components/cli.sh
source $DEV_HOME_DIR/NDevShellRC/components/pbcopy.sh

# NDev
# source $DEV_HOME_DIR/NDevShellRC/components/NDevSSH.sh

########## END ##########
printf "\n"
neofetch
if [[ -r $DEV_HOME_DIR/NDevShellRC/dev-spec/$(hostname).sh ]]; then
    # echo "--------------------------------------------------------------"
    echo "Executing the device-specific script for $(hostname)..."
    echo ""
    source $DEV_HOME_DIR/NDevShellRC/dev-spec/$(hostname).sh
    echo "--------------------------------------------------------------"
fi
source $DEV_HOME_DIR/NDevShellRC/_version.sh
printf "\n"
echo "  #  $NDEV_OSID"
echo ""
echo "  *  Device:          $NDEV_MODEL"
echo "  *  System:          $NDEV_OS ($NDEV_ARCH)"
echo "  *  NDevShellRC:     $NDEVSHELLRC_VERSION '$NDEVSHELLRC_VERSION_MSGLOG'"
printf "\n"
