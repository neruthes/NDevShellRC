# PATH
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh

# Terminal Hacks
source $DEV_HOME_DIR/NDevShellRC/components/cli.sh

# Network
source $DEV_HOME_DIR/NDevShellRC/components/proxy.sh

########## END ##########
printf "\n" >/dev/stderr

source $DEV_HOME_DIR/NDevShellRC/_version.sh
printf "\n" >/dev/stderr
echo "  #  $NDEV_OSID" >/dev/stderr
echo "" >/dev/stderr
echo "  *  Device:          $NDEV_MODEL" >/dev/stderr
echo "  *  System:          $NDEV_OS ($NDEV_ARCH)" >/dev/stderr
echo "  *  NDevShellRC:     $NDEVSHELLRC_VERSION '$NDEVSHELLRC_VERSION_MSGLOG'" >/dev/stderr
printf "\n" >/dev/stderr

neofetch >/dev/stderr
if [[ -r $DEV_HOME_DIR/NDevShellRC/dev-spec/$HOSTNAME.sh ]]; then
    # echo "--------------------------------------------------------------"
    echo "Executing the device-specific script for $HOSTNAME" >/dev/stderr
    echo "" >/dev/stderr
    source $DEV_HOME_DIR/NDevShellRC/dev-spec/$HOSTNAME.sh >/dev/stderr
    echo "--------------------------------------------------------------" >/dev/stderr
fi