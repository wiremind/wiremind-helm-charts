#!/bin/bash

set -e

# Copy scripts to host
#cp /baremetal-config/decrypt-and-mount.sh /tmp/decrypt-and-mount.sh

# This will execute the check / mount scripts in the root namespace
while true; do
    #nsenter -m/proc/1/ns/mnt /baremetal-config/decrypt-and-mount.sh
    bash -c /baremetal-config/decrypt-and-mount.sh

    # Refresh liveness probe
    touch /tmp/raidLivenessFile
    sleep 30
done
