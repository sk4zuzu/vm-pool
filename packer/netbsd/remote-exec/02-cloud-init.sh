#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

(install -d /var/tmp/cloud-init/
 cd /var/tmp/cloud-init/
 git clone https://github.com/canonical/cloud-init.git .
 ./tools/build-on-netbsd)

sync
