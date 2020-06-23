export NDEV_OS_TYPE="macosx"

# PATH
source $DEV_HOME_DIR/NDevShellRC/components/rust.sh
export PATH="$PATH:$HOME/.local/bin"

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh
source $DEV_HOME_DIR/NDevShellRC/components/clipass.sh

# NDev-Sync
source $DEV_HOME_DIR/NDevShellRC/components/NDev-Sync.sh

########## END ##########
source $DEV_HOME_DIR/NDevShellRC/_version.sh
echo "NDevShellRC version: $NDEVSHELLRC_VERSION"
