#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

cat >>/etc/rc.conf <<'EOF'
sendmail_enable=NO
sendmail_submit_enable=NO
sendmail_outbound_enable=NO
sendmail_msp_queue_enable=NO
EOF

>/etc/resolv.conf

sync
