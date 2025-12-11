#!/usr/bin/env bash

: "${K3S_RELEASE:=1.34.2}"
: "${K3S_VERSION:=v${K3S_RELEASE}+k3s1}"
: "${KUBEVIP_CLOUD_PROVIDER_VERSION:=0.0.12}"
: "${KUBEVIP_VERSION:=1.0.2}"

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL "https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s" \
| install -m u=rwx,go=rx /dev/fd/0 "/usr/local/bin/k3s-$K3S_RELEASE"

ln -s "k3s-$K3S_RELEASE" /usr/local/bin/k3s
ln -s k3s                /usr/local/bin/ctr
ln -s k3s                /usr/local/bin/crictl
ln -s k3s                /usr/local/bin/kubectl

install -m u=rwx,go=rx -d /var/lib/rancher/
install -m u=rwx,go=rx -d /var/lib/rancher/k3s/
install -m u=rwx,go=   -d /var/lib/rancher/k3s/agent/
install -m u=rwx,go=rx -d /var/lib/rancher/k3s/agent/images/

curl -fsSL "https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s-airgap-images-amd64.tar.zst" \
| unzstd -o /var/lib/rancher/k3s/agent/images/k3s-airgap-images-amd64.tar

skopeo copy "docker://ghcr.io/kube-vip/kube-vip-cloud-provider:v$KUBEVIP_CLOUD_PROVIDER_VERSION" \
            docker-archive:/var/lib/rancher/k3s/agent/images/kube-vip-cloud-provider.tar

skopeo copy "docker://ghcr.io/kube-vip/kube-vip:v$KUBEVIP_VERSION" \
            docker-archive:/var/lib/rancher/k3s/agent/images/kube-vip.tar

sync
