#!/bin/bash

echo "We should not actually execute this script."
echo "This is only a note."
exit 0


##################################
# 1. Mount filesystems
##################################
mkdir -p /mnt/finaldist
mount /dev/vda2 /mnt/finaldist
mount /dev/vda1 /mnt/finaldist/efi
mount --bind /var/db/repos/gentoo /mnt/finaldist/var/db/repos/gentoo

### Delete some files
rm /home/live/.bash_history
rm /root/.bash_history


##################################
# 2. Update master system
##################################
cd /root/DEV/NDevShellRC && git pull
emerge --sync
emerge --verbose --update --newuse --tree --complete-graph --ask=n --with-bdeps=y --autounmask-continue --keep-going @world
eclean-kernel -n 1
grub-mkconfig -o /boot/grub/grub.cfg


##################################
# 3. Synchronize files
##################################
rsync --delete -avpx /home/ /mnt/finaldist/home/ --exclude live/.cache --exclude live/.mozilla --exclude live/.local --exclude live/.bash_history
rsync --delete -avpx /sbin/ /mnt/finaldist/sbin/
rsync --delete -avpx /bin/ /mnt/finaldist/bin/
rsync --delete -avpx /root/ /mnt/finaldist/root/ --exclude .cache --exclude .mozilla --exclude .local --exclude .bash_history
rsync --delete -avpx /lib/ /mnt/finaldist/lib/ --exclude modules --exclude firmware
rsync --delete -avxx /var/ /mnt/finaldist/var/ --exclude db/repos/gentoo --exclude cache/distfiles --exclude spool/nullmailer --exclude log --exclude 'tmp/*' 
rsync --delete -avpx /lib64/ /mnt/finaldist/lib64/

### Extra files in dist /usr
OTHERUSRFILES="bin/sudo bin/whoami"
for FN in $OTHERUSRFILES; do
    cp --archive /usr/$FN /mnt/finaldist/usr/$FN
done

### Sync /boot only when there is new kernel
rsync --delete -avpx /boot/ /mnt/finaldist/boot/

### Sync /etc and remake fstab
rsync --delete -avp /etc/ /mnt/finaldist/etc/
echo "############## NLive-Gentoo" >/mnt/finaldist/etc/fstab
echo "UUID=f7b0dcde-1980-478a-8898-1e1123544d99     /       ext4        rw,noatime      0 1" >>/mnt/finaldist/etc/fstab
echo "UUID=6108-828E    /efi            vfat        rw,noatime      0 2" >>/mnt/finaldist/etc/fstab
echo "/sqfs.usr         /usr            squashfs    ro,noatime,errors=continue      0 2" >>/mnt/finaldist/etc/fstab
echo "/sqfs.opt         /opt            squashfs    ro,noatime,errors=continue      0 2" >>/mnt/finaldist/etc/fstab
echo "/sqfs.lib         /lib            squashfs    ro,noatime,errors=continue      0 2" >>/mnt/finaldist/etc/fstab
echo "tmpfs             /tmp            tmpfs       rw,noatime          0 2" >>/mnt/finaldist/etc/fstab



##################################
# 4. Create SquashFS images
##################################
EXCL_LIST_FILE=/nlive/filldistdir_excluded_dirs
echo "/tmp/*
/nlive
/swapfile
/sys
/dev
/proc
/run
/mnt/*
/boot
/etc
/root
/home
/sbin
/bin" > $EXCL_LIST_FILE

### Create SquashFS images
rm /nlive/sqfs.*
rm /mnt/finaldist/sqfs.*
function _mksq() {
    SQNAME=$1
    EXCLARGS=$2
    mksquashfs /$1 /nlive/sqfs.$1 -comp zstd -b 1M -one-file-system -Xcompression-level 22 -info -progress $EXCLARGS
}
_mksq usr "-e /usr/src /usr/libexec/gcc /usr/lib/gcc/x86_64-pc-linux-gnu /usr/x86_64-pc-linux-gnu /usr/lib/rust"
_mksq lib
_mksq opt
cp --archive /nlive/sqfs.usr /mnt/finaldist/sqfs.usr
cp --archive /nlive/sqfs.lib /mnt/finaldist/sqfs.lib
cp --archive /nlive/sqfs.opt /mnt/finaldist/sqfs.opt




##################################
# 5. Chroot
##################################
### Normal Mount
    # mount -t squashfs -o loop /mnt/finaldist/output.squashfs /mnt/finaldist/squashfs
    # for i in lib opt usr; do
    #     mount --rbind /mnt/finaldist/squashfs/$i /mnt/finaldist/$i
    # done
    # for i in sys dev proc run/udev; do
    #     mount --rbind /$i /mnt/finaldist/$i
    # done
    # mount --rbind /var/db/repos /mnt/finaldist/var/db/repos

### Building Mount
    for i in lib opt usr; do
        mount --rbind /$i /mnt/finaldist/$i
    done
    mkdir -p /mnt/finaldist/run/udev
    for i in sys dev proc run/udev; do
        mount --rbind /$i /mnt/finaldist/$i
    done

### Continue to chroot
chroot /mnt/finaldist /bin/bash
export PS1="\n(chroot) ${PS1:2}"


##################################
# 6. Initramfs
##################################
KERNELVER="5.14.12-gentoo-dist"

### No longer need the initramfs from genkernel since we build our own
### But we still need it as the template for further customization
genkernel initramfs
cd /usr/src/initramfs
rm -rf * /usr/src/initramfs/*
cpio --extract --make-directories --format=newc --no-absolute-filenames < /boot/initramfs-$KERNELVER.img
rsync -avpx --delete /usr/src/initramfs/ /usr/src/initramfs-nlive/

### Prepare our directory
cd /usr/src/initramfs-nlive
touch NLIVE_INITRAMFS

### Insert the following code into the init script
### This section should be added before copyKeymap
### This practice should be avoided if fstab can do the job
### Or we can use OverlayFS?

######################################
##### INITRAMFS INIT SCRIPT ONLY #####
log_msg "About to mount SquashFS and OverlayFS"
modprobe overlayfs
modprobe squashfs
# mount -t tmpfs -o rw,noatime /newroot/tmp
# for LAYER in upper lower work; do
#     for DIR in usr opt lib; do
#         mkdir -p /newroot/tmp/OverlayFS/$LAYER/$DIR
#     done
# done
for i in usr opt lib; do
    mount /newroot/sqfs.$i /newroot/$i
    # mount -t overlay overlay -o lowerdir=/newroot/tmp/OverlayFS/lower/$i,upperdir=/newroot/tmp/OverlayFS/upper/$i,workdir=/newroot/tmp/OverlayFS/work/$i /$i
done
log_msg "Should have mounted SquashFS"
if [ -e /newroot/opt/firefox/defaults ]; then
    good_msg "Yes, we can find mounted content"
else
    bad_msg "No, the mount failed"
fi
##### INITRAMFS INIT SCRIPT ONLY #####
######################################

### Need these kernel modules in initramfs
MODLIST="kernel/fs/squashfs/squashfs.ko kernel/fs/overlayfs/overlay.ko"
for MOD in $MODLIST; do
    echo "Copying   /lib/modules/$KERNELVER/$MOD  ->  /usr/src/initramfs-nlive/lib/modules/$KERNELVER/$MOD"
    cp --archive /lib/modules/$KERNELVER/$MOD /usr/src/initramfs-nlive/lib/modules/$KERNELVER/$MOD
done

### Make our own initramfs
cd /usr/src/initramfs-nlive
find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > /boot/initramfs-$KERNELVER.img



##################################
# 7. Grub
##################################

### Remember to generate grub.cfg when upgrading kernel version
# grub-install --removable --target=x86_64-efi --efi-directory=/efi
grub-mkconfig -o /boot/grub/grub.cfg

