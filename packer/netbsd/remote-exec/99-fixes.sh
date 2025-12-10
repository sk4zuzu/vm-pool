#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

pip3 install jsonpatch # required by cloud-init

cat >>/etc/dhcpcd.conf <<'EOF'
denyinterfaces vioif0
EOF

>/etc/resolv.conf

sync
