#!/usr/bin/env ksh

set -o errexit -o nounset -o pipefail
set -x

cat >>/etc/rc.conf.local <<'EOF'
smtpd_flags=NO
EOF

>/etc/resolv.conf

sync
