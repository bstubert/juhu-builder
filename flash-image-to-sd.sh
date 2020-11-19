#!/bin/bash

# PRECONDITION: The script expects that you have partitioned the SD card 
# with the companion script partition-sd.sh. 

# The script is run from $WORKDIR, which contains the subdirectories juhu-builder (with
# this script) and korbinian (with the Yocto source and build tree). It expects the Linux
# kernel, DTB files, rootfs tarball and u-boot in the directory 
#
#     $WORKDIR/korbinian/build/tmp/deploy/images/seco-sbc-a62
#
# If the script doesn't find a u-boot image, it doesn't flash u-boot. You need not flash u-boot
# every time you flash the SD image. It's enough to flash it once on the SD card and then
# flash it only, when u-boot changes. This will be rare.
#
# Put the SD card into an adapter and insert the adapter into your PC.
# Figure out the device file (e.g., /dev/sdd) under which the SD card is mounted. The mount
# directory is in /media/<username>. You pass the device file as the first argument to this
# script. For example, call the script as
#
#     ./yocto-builder/flash-image-to-sd.sh /dev/sdd
#


deviceFile=${1}
partition1=${1}1
partition2=${1}2
imageDir=$(pwd)/korbinian/build/tmp/deploy/images/seco-sbc-a62

/bin/umount ${deviceFile}*

# Flashing u-boot image before the start of partition 1.
if [ -f ${imageDir}/u-boot.imx ]; then
    echo "Flashing ${imageDir}/u-boot.imx to ${deviceFile}"
    /bin/dd if=${imageDir}/u-boot.imx of=${deviceFile} bs=512 seek=2 conv=fsync
fi

# Flashing Linux kernel and DTB file to partition 1 of SD card
bootDir=/media/boot
/bin/rm -fr ${bootDir}
/bin/mkdir ${bootDir}
/bin/mount ${partition1} ${bootDir}

echo "Flashing ${imageDir}/zImage to ${partition1}"
cp ${imageDir}/zImage $bootDir
cp ${imageDir}/imx6q-seco_SBC_A62.dtb $bootDir

# Flashing root filesystem to partition 2 of SD card
rootfsDir=/media/rootfs
/bin/rm -fr ${rootfsDir}
/bin/mkdir ${rootfsDir}
/bin/mount ${partition2} ${rootfsDir}

rootfsImage=juhu-image-test-qt-seco-sbc-a62.tar.bz2
echo "Flashing ${imageDir}/${rootfsImage} to ${partition2}"
tar xjpf ${imageDir}/${rootfsImage} --numeric-owner -C ${rootfsDir}

/bin/sync

/bin/umount ${deviceFile}*

