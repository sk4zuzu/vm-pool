#!/usr/bin/env sh

: "${CLOUD_INIT_RELEASE:=22.3.4}"

set -o errexit -o nounset -o pipefail
set -x

(install -d /var/tmp/cloud-init/
 cd /var/tmp/cloud-init/
 git clone -b "$CLOUD_INIT_RELEASE" https://github.com/canonical/cloud-init.git .
 ./tools/build-on-netbsd)

sync
