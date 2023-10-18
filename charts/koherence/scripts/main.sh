#!/bin/sh

set -x
set -e

# Copy binaries to host
/bin/cp /usr/bin/koherence /usr/bin/jq -t /run/koherence/

while true; do
    # Do not redirect even to jq to exit in case of error
    /bin/nsenter -m/proc/1/ns/mnt /run/koherence/koherence check bs 1> /run/koherence/diff.json
    sleep $KOHERENCE_SLEEP_SECONDS
done
