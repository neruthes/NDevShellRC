function rsyncBackup() {
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /home/neruthes /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/home-neruthes
}
function rsyncBackup--full() {
    rsyncBackup
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /etc /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/etc
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /var /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/var
    sudo ~/DEV/rsync-time-backup/rsync_tmbackup.sh /usr /mnt/NEPd2_Archer/Archer_LS/RsyncTimeMachine/usr
}
