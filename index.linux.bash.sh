export NDEV_OS_TYPE="linux"
rm -r ~/Desktop

# PATH
source $DEV_HOME_DIR/NDevShellRC/components/rust.sh
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$DEV_HOME_DIR/NDevShellRC/bin"

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh
source $DEV_HOME_DIR/NDevShellRC/components/clipass.sh

# Drives
source $DEV_HOME_DIR/NDevShellRC/components/NDevExtPd2-Archer.sh
source $DEV_HOME_DIR/NDevShellRC/components/rsyncBackup.sh
source $DEV_HOME_DIR/NDevShellRC/components/dropbox-encfs.sh
source $DEV_HOME_DIR/NDevShellRC/components/encfs-home.sh

# Network
source $DEV_HOME_DIR/NDevShellRC/components/ssmgr.sh

# Terminal Hacks
source $DEV_HOME_DIR/NDevShellRC/components/tty.sh
source $DEV_HOME_DIR/NDevShellRC/components/pbcopy.sh

# NDev-Sync
source $DEV_HOME_DIR/NDevShellRC/components/NDev-Sync.sh
NDevSyncHelper

########## END ##########
source $DEV_HOME_DIR/NDevShellRC/_version.sh
echo "NDevShellRC version: $NDEVSHELLRC_VERSION"
