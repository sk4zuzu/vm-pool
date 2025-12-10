#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

gawk -i inplace -f- /etc/rc.conf <<'AWK'
BEGIN { update = "rc_cgroup_mode=\"unified\"" }
/^[#\s]*rc_cgroup_mode=/ { $0 = update; found = 1 }
{ print }
ENDFILE { if (!found) print update }
AWK

rc-update add cgroups boot

sync
