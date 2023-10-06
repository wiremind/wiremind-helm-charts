#!/bin/sh

set -xe

# Copy scripts to host
/bin/cp /tmp/script/* /usr/bin/koherence /usr/bin/jq -t /run/koherence/

while true; do
    /bin/nsenter -m/proc/1/ns/mnt /run/koherence/koherence check bs | /run/koherence/jq '.diff'
    sleep $KOHERENCE_SLEEP_SECONDS
done
