#!/bin/sh
set -x
set -e

RAID_DEVICE="/dev/md/md0"
DECRYPTED_LUKS_DEVICE_NAME="md0crypt"
DECRYPTED_LUKS_DEVICE="/dev/mapper/md0crypt"
LVM_PARTITION_DEVICES="/dev/md0cryptlvm/persistentvolume*"

# Decrypt
if ! cryptsetup status $DECRYPTED_LUKS_DEVICE_NAME; then
    echo "Decrypting device..."
    set +x  # Do not log password, please.
    # XXX: this will actually hang (even if successfully opening) when run like this.
    # When run locally, even from a script, it works.
    # It will anyway get killed by the livenessprobe.
    echo -n "$password" | cryptsetup luksOpen --verbose $RAID_DEVICE $DECRYPTED_LUKS_DEVICE_NAME --verbose --debug --allow-discards --key-file -
    echo "Done."
    set -x
fi

# Check, will exit non-0 if failed
cryptsetup status $DECRYPTED_LUKS_DEVICE
pvscan
vgscan

# Mount every /dev/md0cryptlvm/persistentvolumeX to /mnt/persistentvolumeX
for PARTITION_DEVICE in $LVM_PARTITION_DEVICES; do
    # When there is no matching device
    if [ "$PARTITION_DEVICE" = "$LVM_PARTITION_DEVICES" ]; then
      echo "No lvm partition found"
      continue
    fi
    if ! findmnt "$PARTITION_DEVICE"; then
        mount -t ext4 "$PARTITION_DEVICE" /mnt/$(basename "$PARTITION_DEVICE")
    fi
done

# Check
for PARTITION_DEVICE in $LVM_PARTITION_DEVICES; do
    # When there is no matching device
    if [ "$PARTITION_DEVICE" = "$LVM_PARTITION_DEVICES" ]; then
      echo "No lvm partition found"
      continue
    fi
    echo "Checking $PARTITION_DEVICE mount point..."
    findmnt "$PARTITION_DEVICE"
done
