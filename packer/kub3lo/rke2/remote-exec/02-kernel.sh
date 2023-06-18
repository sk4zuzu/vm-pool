#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

gawk -i inplace -f- /etc/modules <<'EOF'
/^9pnet_virtio/ { found=1 }
{ print }
ENDFILE { if (!found) print "9pnet_virtio" }
EOF

gawk -i inplace -f- /etc/default/grub.d/50-cloudimg-settings.cfg <<'EOF'
/^GRUB_CMDLINE_LINUX_DEFAULT=/ { found=1 }
/^GRUB_CMDLINE_LINUX_DEFAULT=/ && !/net.ifnames=0/ { gsub(/"$/, " net.ifnames=0\"") }
{ print }
ENDFILE { if (!found) print "GRUB_CMDLINE_LINUX_DEFAULT=\"net.ifnames=0\"" }
EOF

update-grub

sync
