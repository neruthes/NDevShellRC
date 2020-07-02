export NDEV_OS_TYPE="macosx"

# PATH
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh
source $DEV_HOME_DIR/NDevShellRC/components/clipass.sh

# NDev
source $DEV_HOME_DIR/NDevShellRC/components/NDev-Sync.sh
source $DEV_HOME_DIR/NDevShellRC/components/NDev-SSH.sh

########## END ##########
source $DEV_HOME_DIR/NDevShellRC/_version.sh
echo "NDevShellRC version: $NDEVSHELLRC_VERSION"
