if [[ `uname` == Darwin ]]; then
    exit 1
fi


function borgBackup() {
    if [[ -r /mnt/NEPd3_Caster/LS/BorgHome/NDLT7 ]]; then
        echo ""
        echo "Borg backup starting..."
        echo ""

        function stddatetime() {
            Date1=$(date -Is)
            Date2=${Date1:0:19}
            Date3=${Date2/:/}
            Date4=${Date3/:/}
            DateX=${Date4/T/-}
            printf $DateX
        }

        export REPO_PREFIX="/mnt/NEPd3_Caster/LS/BorgHome/NDLT7"

        NDevVar set syslock-borgBackup LOCKED

        if [[ $1 == 'system' ]]; then
            sudo borg create --stats \
                --list \
                --exclude '/etc/mtab' \
                --exclude '/usr/tmp' \
                --exclude '/var/lock' \
                --exclude '/var/run' \
                --exclude '/var/tmp' \
                --compression zstd,22 \
                --one-file-system \
                ${REPO_PREFIX}/system::$(stddatetime) \
                /etc /usr /var /boot
        fi

        if [[ $1 == 'neruthes' ]]; then
            borg create --stats \
                --list \
                --exclude '/home/neruthes/.cache' \
                --exclude '/home/neruthes/*/.cache' \
                --compression zstd,22 \
                --one-file-system \
                ${REPO_PREFIX}/neruthes::$(stddatetime) \
                /home/neruthes
        fi

        NDevVar del syslock-borgBackup

        echo ""
        echo "Borg backup completed."
    else
        echo "Error: Path '/mnt/NEPd3_Caster/BorgHome/NDLT7' cannot be found!"
    fi
}
