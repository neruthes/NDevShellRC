if [[ `uname` == Darwin ]]; then
    exit 1
fi

function rsyncBackup() {
    NDevVar set syslock-rsyncBackup LOCKED
    /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /home/neruthes /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/home-neruthes /home/neruthes/DEV/NDevShellRC/config/rsyncBackup-excluded-files.txt
    NDevVar del syslock-rsyncBackup
}
function rsyncBackup--full() {
    rsyncBackup
    NDevVar set syslock-rsyncBackup LOCKED
    sudo /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /etc /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/etc
    sudo /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /var /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/var
    sudo /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /usr /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/usr
    NDevVar del syslock-rsyncBackup
}
