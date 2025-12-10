#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add \
    haproxy \
    nfs-utils \
    open-iscsi

rc-update add haproxy
rc-update add iscsid

sync
