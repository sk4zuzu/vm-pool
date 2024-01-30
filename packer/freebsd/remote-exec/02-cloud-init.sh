#!/usr/bin/env bash

: "${CLOUD_INIT_RELEASE:=23.4.2}"

set -o errexit -o nounset -o pipefail
set -x

(install -d /var/tmp/cloud-init/
 cd /var/tmp/cloud-init/
 git clone -b "$CLOUD_INIT_RELEASE" https://github.com/canonical/cloud-init.git .
 ./tools/build-on-freebsd)

sync
