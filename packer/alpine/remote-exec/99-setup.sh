#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

setup-keymap us us

setup-timezone -z UTC

apk --no-cache add openntpd
rc-service openntpd start
rc-update add openntpd

apk --no-cache add util-linux cloud-init
setup-cloud-init

(yes | setup-disk -m sys /dev/vda) || true

sync
