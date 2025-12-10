#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

cat >/etc/ssh/sshd_config.d/99-fixes.conf <<'EOF'
AllowTcpForwarding yes
EOF

sync
