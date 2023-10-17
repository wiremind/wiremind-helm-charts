#!/bin/sh

set -xe

# Copy binaries to host
/bin/cp /usr/bin/koherence /usr/bin/jq -t /run/koherence/

while true; do
    /bin/nsenter -m/proc/1/ns/mnt /run/koherence/koherence check bs | /run/koherence/jq '.diff'
    sleep $KOHERENCE_SLEEP_SECONDS
done
