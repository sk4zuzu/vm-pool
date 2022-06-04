#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

systemctl disable NetworkManager-wait-online.service

install -o 0 -g 0 -m u=rw,go=r -D /dev/fd/0 /etc/cloud/cloud.cfg.d/99_network.cfg <<'EOF'
network:
  config: disabled
EOF

dnf install -y \
    systemd-networkd

systemctl enable systemd-networkd

install -o systemd-network -g systemd-network -m ug=rwx,o=rx -d /etc/systemd/network/

sync
