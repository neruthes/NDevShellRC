if [[ "$(uname)" != "Linux" ]]; then
    echo "This component can only work on Linux!"
fi

function borgBackup() {
    # $1 = system|neruthes

    # if [[ -r /mnt/NEPd3_Caster/LS/BorgHome/NDLT7 ]]; then


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

        # export REPO_PREFIX="/mnt/NEPd3_Caster/LS/BorgHome/NDLT7"                  ### For NDLT7 local backup
        export REPO_PREFIX="ssh://neruthes@NDLT6G:22/mnt/NEPd3_Caster/LS/BorgHome/NDLT7"    ### When NEPd3 is connected at NDLT6G

        if [[ "$(NDevVar get syslock-borgBackup 2>/dev/null)" == "LOCKED" ]]; then
            echo "ERROR: An existing backup session is active"
            return 1
        fi
        NDevVar set syslock-borgBackup LOCKED

        echo "Starting backup job..."
        case "$1" in
            system )
                export REPO_PREFIX="ssh://root@NDLT6G:22/mnt/NEPd3_Caster/LS/BorgHome/NDLT7"
                sudo borg create --stats \
                    --list \
                    --exclude '/etc/mtab' \
                    --exclude '/usr/tmp' \
                    --exclude '/var/lock' \
                    --exclude '/var/run' \
                    --exclude '/var/tmp' \
                    --compression zstd,22 \
                    --one-file-system \
                    "${REPO_PREFIX}/system::$(stddatetime)" \
                    /etc /usr /var /boot
                ;;
            neruthes )
                borg create --stats \
                    --list \
                    --exclude '/home/neruthes/.cache' \
                    --exclude '/home/neruthes/.chrootjail' \
                    --exclude '/home/neruthes/.config/discord' \
                    --exclude '/home/neruthes/.config/yarn' \
                    --exclude '/home/neruthes/.local/share/TelegramDesktop/tdata/user_data/media_cache' \
                    --exclude '/home/neruthes/*/.cache' \
                    --compression zstd,22 \
                    --one-file-system \
                    "${REPO_PREFIX}/neruthes::$(stddatetime)" \
                    /home/neruthes
                ;;
        esac

        NDevVar del syslock-borgBackup

        echo ""
        echo "Borg backup completed."
    
    
    
    
    
    # else
        # echo "Error: Path '/mnt/NEPd3_Caster/LS/BorgHome/NDLT7' cannot be found!"
    # fi
}
