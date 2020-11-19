#!/bin/bash

# Call the script from $WORKDIR
#
#     ./yocto-builder/partition-sd.sh /dev/sdx
#
# Replace /dev/sdx by the device file on which the SD card gets mounted (e.g., /dev/sdd).
# The script wipes all content from the data and then creates two partitions:
#   - Partition 1 is a 32 MB vfat partition for booting the Linux kernel.
#   - Partition 2 takes the rest of the SD card and contains the root filesystem.
#
# You need to partition the SD card only once. From then on, you will only flash u-boot,
# Linux kernel and Linux rootfs on the SD card with the companion script flash-image-to-sd.sh.

deviceFile=${1}
partition1=${1}1
partition2=${1}2

umount ${deviceFile}*
sleep 3

echo "Erasing SD card: ${deviceFile}"
dd if=/dev/zero of=${deviceFile} bs=512 count=2000
sleep 3
sync

echo "Creating 1st partition: boot"
(echo o; echo n; echo p; echo 1; echo ; echo +32M; echo w) | fdisk ${deviceFile}
sleep 3
sync

echo "Creating 2nd partition: rootfs"
(echo n; echo p; echo 2; echo ; echo ; echo w) | fdisk ${deviceFile}
sleep 3

echo "Changing partition types: 1 = W95 FAT32, 2 = Linux"
(echo t; echo 1; echo b; echo t; echo 2; echo 83; echo w) | fdisk ${deviceFile}
sleep 3

echo "Creating vfat filesystem on partition 1"
mkfs.vfat ${partition1}
sleep 3

echo "Creating ext3 filesystem on partition 2"
mkfs.ext3 -F ${partition2}
sleep 3
sync

