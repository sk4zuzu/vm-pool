#!/usr/bin/env bash

: "${RKE2_RELEASE:=1.27.2}"
: "${RKE2_VERSION:=v${RKE2_RELEASE}+rke2r1}"

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2.linux-amd64.tar.gz" \
| tar -xz -f- -C /usr/local/

ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl

install -m u=rwx,go=rx -d /var/lib/rancher/
install -m u=rwx,go=rx -d /var/lib/rancher/rke2/
install -m u=rwx,go=   -d /var/lib/rancher/rke2/agent/
install -m u=rwx,go=rx -d /var/lib/rancher/rke2/agent/images/

curl -fsSL "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2-images-core.linux-amd64.tar.zst" \
| unzstd -o /var/lib/rancher/rke2/agent/images/rke2-images-core.linux-amd64.tar

curl -fsSL "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2-images-canal.linux-amd64.tar.zst" \
| unzstd -o /var/lib/rancher/rke2/agent/images/rke2-images-canal.linux-amd64.tar

sync
