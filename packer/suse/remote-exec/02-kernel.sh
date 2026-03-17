#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

zypper --non-interactive install -y --force-resolution kernel-default

gawk -i inplace -f- /etc/default/grub <<'AWK'
/^GRUB_CMDLINE_LINUX_DEFAULT=/ { found = 1 }
/^GRUB_CMDLINE_LINUX_DEFAULT=/ && !/net.ifnames=0/ { gsub(/"$/, " net.ifnames=0\"") }
/^GRUB_CMDLINE_LINUX_DEFAULT=/ && !/biosdevname=0/ { gsub(/"$/, " biosdevname=0\"") }
{ print }
ENDFILE { if (!found) print "GRUB_CMDLINE_LINUX_DEFAULT=\"net.ifnames=0 biosdevname=0\"" }
AWK

grub2-mkconfig -o /boot/grub2/grub.cfg

sync
