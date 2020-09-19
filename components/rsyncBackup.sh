function rsyncBackup() {
    NDevVar set syslock-rsyncBackup LOCKED
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /home/neruthes /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/home-neruthes /home/neruthes/DEV/NDevShellRC/config/rsyncBackup-excluded-files.txt
    NDevVar del syslock-rsyncBackup
}
function rsyncBackup--full() {
    rsyncBackup
    NDevVar set syslock-rsyncBackup LOCKED
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /etc /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/etc
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /var /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/var
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /usr /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/usr
    NDevVar del syslock-rsyncBackup
}
