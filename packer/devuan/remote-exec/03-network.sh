#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

install -o 0 -g 0 -m u=rw,go=r -D /dev/fd/0 /etc/cloud/cloud.cfg.d/99_network.cfg <<'EOF'
network:
  config: disabled
EOF

cat >/etc/network/interfaces <<'EOF'
source /etc/network/interfaces.d/*
EOF

cat >/etc/network/interfaces.d/00-lo <<'EOF'
auto lo
iface lo inet loopback
EOF

sync
