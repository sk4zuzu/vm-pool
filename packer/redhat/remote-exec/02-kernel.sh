#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

grubby --update-kernel=ALL --args='net.ifnames=0 biosdevname=0'

rpm --import https://www.elrepo.org/RPM-GPG-KEY-v2-elrepo.org

(source /etc/os-release && IFS=. read -ra V <<< "$VERSION_ID" \
                        && dnf install -y "https://www.elrepo.org/elrepo-release-${V[0]}.el${V[0]}.elrepo.noarch.rpm")

dnf --enablerepo=elrepo-kernel install -y kernel-ml

cat >/etc/modules-load.d/9pnet_virtio.conf <<'EOF'
9pnet_virtio
EOF

sync
