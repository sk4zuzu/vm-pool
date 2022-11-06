#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

cat >>/etc/dhcpcd.conf <<EOF
denyinterfaces vioif0
EOF

>/etc/resolv.conf

sync
