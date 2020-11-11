if [[ `uname` == Darwin ]]; then
    exit 1
fi

function rsyncBackup() {
    NDevVar set syslock-rsyncBackup LOCKED
    /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /home/neruthes /mnt/NEPd3_Caster/LS/RsyncTimeMachine/home-neruthes /home/neruthes/DEV/NDevShellRC/config/rsyncBackup-excluded-files.txt
    NDevVar del syslock-rsyncBackup
}
function rsyncBackup--full() {
    rsyncBackup
    NDevVar set syslock-rsyncBackup LOCKED
    sudo /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /etc /mnt/NEPd3_Caster/LS/RsyncTimeMachine/etc
    sudo /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /var /mnt/NEPd3_Caster/LS/RsyncTimeMachine/var
    sudo /home/neruthes/DEV/rsync-time-backup/rsync_tmbackup.sh /usr /mnt/NEPd3_Caster/LS/RsyncTimeMachine/usr
    NDevVar del syslock-rsyncBackup
}
