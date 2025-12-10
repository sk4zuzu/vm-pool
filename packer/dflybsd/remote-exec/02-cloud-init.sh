#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

pkg install -y py311-cloud-init

gawk -i inplace -f- /etc/rc.conf <<'AWK'
BEGIN { update = "cloudinit_enable=YES" }
/^[#\s]*cloudinit_enable=/ { $0 = update; found = 1 }
{ print }
ENDFILE { if (!found) print update }
AWK

sync
