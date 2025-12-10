#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

# disable DHCP
gawk -i inplace -f- /etc/rc.conf <<'AWK'
/^ifconfig_DEFAULT=/ { $0 = "#" $0 }
{ print }
AWK

cat >>/etc/rc.conf <<'EOF'
sendmail_enable=NO
sendmail_submit_enable=NO
sendmail_outbound_enable=NO
sendmail_msp_queue_enable=NO
EOF

>/etc/resolv.conf
>/firstboot # fix nuageinit

sync
