export NDEV_OS_TYPE="macosx"

# PATH
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh

# Terminal Hacks
source $DEV_HOME_DIR/NDevShellRC/components/cli.sh

# Network
source $DEV_HOME_DIR/NDevShellRC/components/proxy.sh

########## END ##########
source $DEV_HOME_DIR/NDevShellRC/_version.sh
echo "NDevShellRC version: $NDEVSHELLRC_VERSION"
