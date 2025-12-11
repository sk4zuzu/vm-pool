#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add \
    nfs-utils \
    open-iscsi

rc-update add iscsid

sync
