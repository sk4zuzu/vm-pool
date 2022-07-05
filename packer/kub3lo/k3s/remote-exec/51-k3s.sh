#!/usr/bin/env bash

: "${K3S_RELEASE:=1.24.2}"
: "${K3S_VERSION:=v${K3S_RELEASE}+k3s1}"

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL "https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s" \
| install -m u=rwx,go=rx /dev/fd/0 "/mnt/usr/local/bin/k3s-$K3S_RELEASE"

ln -s "k3s-$K3S_RELEASE" /mnt/usr/local/bin/k3s
ln -s "k3s"              /mnt/usr/local/bin/kubectl

install -m u=rwx,go=rx -d /mnt/var/lib/rancher/
install -m u=rwx,go=rx -d /mnt/var/lib/rancher/k3s/
install -m u=rwx,go=   -d /mnt/var/lib/rancher/k3s/agent/
install -m u=rwx,go=rx -d /mnt/var/lib/rancher/k3s/agent/images/

curl -fsSL "https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s-airgap-images-amd64.tar.zst" \
| unzstd -o /mnt/var/lib/rancher/k3s/agent/images/k3s-airgap-images-amd64.tar

sync
