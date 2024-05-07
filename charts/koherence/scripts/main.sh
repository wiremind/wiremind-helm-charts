#!/bin/sh

set -x
set -e

# Copy binaries to host
/bin/cp /usr/bin/koherence /usr/bin/jq -t /run/koherence/

/bin/nsenter -m/proc/1/ns/mnt /run/koherence/koherence serve
