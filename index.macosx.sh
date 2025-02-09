# PATH
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh

# Terminal Hacks
source $DEV_HOME_DIR/NDevShellRC/components/cli.sh

# Network
source $DEV_HOME_DIR/NDevShellRC/components/proxy.sh

########## END ##########
printf "\n" >&2

source $DEV_HOME_DIR/NDevShellRC/_version.sh
printf "\n" >&2
echo "  #  $NDEV_OSID" >&2
echo "" >&2
echo "  *  Device:          $NDEV_MODEL" >&2
echo "  *  System:          $NDEV_OS ($NDEV_ARCH)" >&2
echo "  *  NDevShellRC:     $NDEVSHELLRC_VERSION" >&2
printf "\n" >&2

neofetch >&2
if [[ -r "$DEV_HOME_DIR/NDevShellRC/dev-spec/$HOSTNAME.sh" ]]; then
    # echo "--------------------------------------------------------------"
    echo "Executing the device-specific script for $HOSTNAME" >&2
    echo "" >&2
    source "$DEV_HOME_DIR/NDevShellRC/dev-spec/$HOSTNAME.sh" >&2
    echo "--------------------------------------------------------------" >&2
fi
