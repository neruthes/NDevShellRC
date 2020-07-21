export NDEV_OS_TYPE="macosx"

# PATH
source $DEV_HOME_DIR/NDevShellRC/components/PATH.sh

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh

# NDev
source $DEV_HOME_DIR/NDevShellRC/components/NDev-SSH.sh

########## END ##########
source $DEV_HOME_DIR/NDevShellRC/_version.sh
echo "NDevShellRC version: $NDEVSHELLRC_VERSION"
