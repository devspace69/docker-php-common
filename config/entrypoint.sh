#!/bin/sh

set -e

# Handle bindmounts (They are listed as: from:to,from:to example: /mnt/files/aalborg,/app/files/aalborg), they are in an ENV called BIND_MOUNTS
if [ -n "$BIND_MOUNTS" ]; then
    for mount in $(echo "$BIND_MOUNTS" | tr "," "\n")
    do
        from=$(echo "$mount" | cut -d: -f1)
        to=$(echo "$mount" | cut -d: -f2)
        mkdir -p "$from" || true
        mkdir -p "$to" || true
        mount --bind "$from" "$to"
    done
fi

exec "$@"
