#!/bin/sh
set -x
set -e

# Copy scripts to host
cp /baremetal-config/decrypt-and-mount.sh /host-tmp/decrypt-and-mount.sh  # /host-tmp represents /tmp/bare-metal-daemonset for the host

# This will execute the check / mount scripts in the root namespace
while true; do
    /usr/bin/nsenter -m/proc/1/ns/mnt /tmp/bare-metal-daemonset/decrypt-and-mount.sh
    # Refresh liveness probe
    touch /tmp/raidLivenessFile
    sleep 30
done
