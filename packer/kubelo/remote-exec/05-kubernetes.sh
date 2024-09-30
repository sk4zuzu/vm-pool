!/usr/bin/env bash

: "${CRICTL_VERSION:=1.31.1}"
: "${ETCD_VERSION:=3.5.15}"
: "${HELM_VERSION:=3.16.0}"
: "${KUBERNETES_RELEASE_VERSION:=0.17.8}"
: "${KUBERNETES_VERSION:=1.31.1}"
: "${KUBEVIP_VERSION:=0.8.3}"
: "${KUBEVIP_CLOUD_PROVIDER_VERSION:=0.0.10}"

set -o errexit -o nounset -o pipefail
set -x

install -m u=rwx,go=rx -d /etc/systemd/system/kubelet.service.d/

curl -fsSL "https://storage.googleapis.com/etcd/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz" \
| tar -xz -f- -C /usr/local/bin/ --strip-components=1 --no-same-owner \
  "etcd-v$ETCD_VERSION-linux-amd64/etcd" \
  "etcd-v$ETCD_VERSION-linux-amd64/etcdctl"

curl -fsSL "https://github.com/kubernetes-sigs/cri-tools/releases/download/v$CRICTL_VERSION/crictl-v$CRICTL_VERSION-linux-amd64.tar.gz" \
| tar -xz -f- -C /usr/local/bin/ --no-same-owner \
  crictl

curl -fsSL "https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz" \
| tar -xz -f- -C /usr/local/bin/ --strip-components=1 --no-same-owner \
  linux-amd64/helm

curl -fsSL "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubeadm" \
| install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kubeadm

curl -fsSL "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubelet" \
| install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kubelet

curl -fsSL "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubectl" \
| install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kubectl

curl -fsSL "https://raw.githubusercontent.com/kubernetes/release/v$KUBERNETES_RELEASE_VERSION/cmd/krel/templates/latest/kubelet/kubelet.service" \
| install -m u=rw,go=r /dev/fd/0 /etc/systemd/system/kubelet.service

curl -fsSL "https://raw.githubusercontent.com/kubernetes/release/v$KUBERNETES_RELEASE_VERSION/cmd/krel/templates/latest/kubeadm/10-kubeadm.conf" \
| install -m u=rw,go=r /dev/fd/0 /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload

kubeadm config images pull "--kubernetes-version=v$KUBERNETES_VERSION"

ctr image pull "ghcr.io/kube-vip/kube-vip:v$KUBEVIP_VERSION"
ctr image pull "ghcr.io/kube-vip/kube-vip-cloud-provider:v$KUBEVIP_CLOUD_PROVIDER_VERSION"

install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kube-vip <<EOF
#!/usr/bin/env bash
exec ctr run --rm --net-host ghcr.io/kube-vip/kube-vip:v$KUBEVIP_VERSION vip /kube-vip "$$@"
EOF

sync
