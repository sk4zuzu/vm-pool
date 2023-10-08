#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm

dnf --enablerepo=elrepo-kernel install -y kernel-ml

cat >/etc/modules-load.d/9pnet_virtio.conf <<'EOF'
9pnet_virtio
EOF

sync
