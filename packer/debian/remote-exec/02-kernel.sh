#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

gawk -i inplace -f- /etc/modules <<'AWK'
/^9pnet_virtio/ { found = 1 }
{ print }
ENDFILE { if (!found) print "9pnet_virtio" }
AWK

touch /etc/default/grub.d/50-cloudimg-settings.cfg

gawk -i inplace -f- /etc/default/grub.d/50-cloudimg-settings.cfg <<'AWK'
/^GRUB_CMDLINE_LINUX_DEFAULT=/ { found = 1 }
/^GRUB_CMDLINE_LINUX_DEFAULT=/ && !/net.ifnames=0/ { gsub(/"$/, " net.ifnames=0\"") }
/^GRUB_CMDLINE_LINUX_DEFAULT=/ && !/biosdevname=0/ { gsub(/"$/, " biosdevname=0\"") }
{ print }
ENDFILE { if (!found) print "GRUB_CMDLINE_LINUX_DEFAULT=\"net.ifnames=0 biosdevname=0\"" }
AWK

# prevents kernel panics + segfaults
gawk -i inplace -f- /etc/default/grub.d/50-cloudimg-settings.cfg /etc/default/grub <<'AWK'
/^GRUB_CMDLINE_LINUX[^=]*=/ { gsub(/ ?\<quiet\>/, "") }
/^GRUB_CMDLINE_LINUX[^=]*=/ { gsub(/ ?\<splash\>/, "") }
/^GRUB_CMDLINE_LINUX[^=]*=/ { gsub(/ ?\<console=ttyS[^ ]*\>/, "") }
/^GRUB_CMDLINE_LINUX[^=]*=/ { gsub(/ ?\<earlyprintk=ttyS[^ ]*\>/, "") }
/^GRUB_TERMINAL=/ { gsub(/ ?\<serial\>/, "") }
{ print }
AWK

update-grub

sync
