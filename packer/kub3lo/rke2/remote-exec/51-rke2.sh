#!/usr/bin/env bash

: "${RKE2_RELEASE:=1.34.2}"
: "${RKE2_VERSION:=v${RKE2_RELEASE}+rke2r1}"
: "${KUBEVIP_CLOUD_PROVIDER_VERSION:=0.0.12}"
: "${KUBEVIP_VERSION:=1.0.2}"

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2.linux-amd64.tar.gz" \
| tar -xz -f- -C /usr/local/

ln -s /var/lib/rancher/rke2/bin/ctr     /usr/local/bin/ctr
ln -s /var/lib/rancher/rke2/bin/crictl  /usr/local/bin/crictl
ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl

install -m u=rwx,go=rx -d /var/lib/rancher/
install -m u=rwx,go=rx -d /var/lib/rancher/rke2/
install -m u=rwx,go=   -d /var/lib/rancher/rke2/agent/
install -m u=rwx,go=rx -d /var/lib/rancher/rke2/agent/images/

curl -fsSL "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2-images-core.linux-amd64.tar.zst" \
| unzstd -o /var/lib/rancher/rke2/agent/images/rke2-images-core.linux-amd64.tar

curl -fsSL "https://github.com/rancher/rke2/releases/download/$RKE2_VERSION/rke2-images-canal.linux-amd64.tar.zst" \
| unzstd -o /var/lib/rancher/rke2/agent/images/rke2-images-canal.linux-amd64.tar

skopeo copy "docker://ghcr.io/kube-vip/kube-vip-cloud-provider:v$KUBEVIP_CLOUD_PROVIDER_VERSION" \
            docker-archive:/var/lib/rancher/rke2/agent/images/kube-vip-cloud-provider.tar

skopeo copy "docker://ghcr.io/kube-vip/kube-vip:v$KUBEVIP_VERSION" \
            docker-archive:/var/lib/rancher/rke2/agent/images/kube-vip.tar

sync
