#!/bin/bash

set -ex

# XXX Talos uses this format for its raid data: /dev/md/<nodename>:<raid-name>
RAID_NAME="data"
# XXX this is the final name on talos once setup but we cannot create it
# with it cause mdadm exit with this error: "mdadm: Value "metal-002:data"
# cannot be set as devname. Reason: Not POSIX compatible."
#
# So create it with a temporary name like md0 but use the right one with
# topolvm later.
#
# Cause of this error we have to reboot once setup to be sure everything is
# working right.
RAID_DEVICE="/dev/md/$NODENAME:$RAID_NAME"
#RAID_DEVICE="/dev/md/md0"
# XXX we use this as only some commands have to be run from host directly,
# for example it does not contains bash and ls commands
PREFIX="nsenter -m/proc/1/ns/mnt"

# Avoid spam in our logs, just check
$PREFIX mdadm -D "$RAID_DEVICE" &> /dev/null
if [[ "$?" != "0" ]]; then
    echo "Raid device <${RAID_DEVICE}> not found, skipping"
    exit 1
fi

wmb_decrypt_device() {
  if ! $PREFIX cryptsetup status $DECRYPTED_LUKS_DEVICE_NAME; then
      echo "Decrypting the device $DECRYPTED_LUKS_DEVICE_NAME."
      set +x  # Do not log password, please.
      # XXX: this will actually hang (even if successfully opening) when run like this.
      # When run locally, even from a script, it works.
      # It will anyway get killed by the livenessprobe.
      echo -n "$LUKS_PASSWORD" | $PREFIX cryptsetup luksOpen --verbose $RAID_DEVICE $DECRYPTED_LUKS_DEVICE_NAME --verbose --debug --allow-discards --key-file -
      echo "Done decrypting the device $DECRYPTED_LUKS_DEVICE_NAME."
      set -x
  fi

  # Check, will exit non-0 if failed
  $PREFIX cryptsetup status $DECRYPTED_LUKS_DEVICE
  $PREFIX lvm pvscan
  $PREFIX lvm vgscan
}


wmb_mount_partition_devices() {
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
}


wmb_check_partition_devices_mounts() {
  for PARTITION_DEVICE in $LVM_PARTITION_DEVICES; do
      # When there is no matching device
      if [ "$PARTITION_DEVICE" = "$LVM_PARTITION_DEVICES" ]; then
        echo "No lvm partition found"
        continue
      fi
      echo "Checking $PARTITION_DEVICE mount point..."
      findmnt "$PARTITION_DEVICE"
  done
}

# Decrypt
wmb_decrypt_device

# Topolvm manages the mounts/checks on its own.
if [[ -z "$TOPOLVM_ENABLED" ]]; then
    wmb_mount_partition_devices
    wmb_check_partition_devices_mounts
fi
