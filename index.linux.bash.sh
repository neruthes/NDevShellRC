export NDEV_OS_TYPE="linux"

# Productivity
source $DEV_HOME_DIR/NDevShellRC/components/git.sh
source $DEV_HOME_DIR/NDevShellRC/components/clipass.sh
source $DEV_HOME_DIR/NDevShellRC/components/scrot.sh

# Device
source $DEV_HOME_DIR/NDevShellRC/components/scrmgr.sh

# Drives
source $DEV_HOME_DIR/NDevShellRC/components/NDevExtPd2-Archer.sh
source $DEV_HOME_DIR/NDevShellRC/components/rsyncBackup.sh
source $DEV_HOME_DIR/NDevShellRC/components/dropbox-encfs.sh
source $DEV_HOME_DIR/NDevShellRC/components/encfs-home.sh

# PATH
source $DEV_HOME_DIR/NDevShellRC/components/rust.sh
export PATH="$PATH:$HOME/.local/bin"

# Network
source $DEV_HOME_DIR/NDevShellRC/components/ssmgr.sh

# Terminal Hacks
source $DEV_HOME_DIR/NDevShellRC/components/tty.sh
source $DEV_HOME_DIR/NDevShellRC/components/pbcopy.sh

# NDev-Sync
source $DEV_HOME_DIR/NDevShellRC/components/NDev-Sync.sh

# Misc
source $DEV_HOME_DIR/NDevShellRC/components/select-random-file-in-dir.sh

########## END ##########
source $DEV_HOME_DIR/NDevShellRC/_version.sh
echo "NDevShellRC version: $NDEVSHELLRC_VERSION"
