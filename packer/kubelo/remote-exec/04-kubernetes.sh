#!/usr/bin/env bash

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

: "${CRICTL_VERSION:=1.34.0}"
: "${ETCD_VERSION:=3.6.6}"
: "${HELM_VERSION:=4.0.0}"
: "${KUBERNETES_RELEASE_VERSION:=0.18.0}"
: "${KUBERNETES_VERSION:=1.34.2}"
: "${KUBEVIP_CLOUD_PROVIDER_VERSION:=0.0.12}"
: "${KUBEVIP_VERSION:=1.0.2}"
: "${FLANNEL_VERSION:=0.27.4}"

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

apt-get -q update -y

policy_rc_d_disable

apt-get install -y conntrack socat # required by kubeadm

policy_rc_d_enable

apt-get -q clean

install -m u=rw,go=r /dev/fd/0 /etc/modules-load.d/k8s.conf <<'EOF'
overlay
br_netfilter
EOF

install -m u=rw,go=r /dev/fd/0 /etc/sysctl.d/k8s.conf <<'EOF'
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

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

curl -fsSL "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubectl" \
| install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kubectl

curl -fsSL "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubelet" \
| install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kubelet

ln -s /usr/local/bin/kubelet /usr/bin/kubelet # so no modifications are needed in kubelet.service

curl -fsSL "https://raw.githubusercontent.com/kubernetes/release/v$KUBERNETES_RELEASE_VERSION/cmd/krel/templates/latest/kubelet/kubelet.service" \
| install -m u=rw,go=r /dev/fd/0 /etc/systemd/system/kubelet.service

curl -fsSL "https://raw.githubusercontent.com/kubernetes/release/v$KUBERNETES_RELEASE_VERSION/cmd/krel/templates/latest/kubeadm/10-kubeadm.conf" \
| install -m u=rw,go=r /dev/fd/0 /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload

kubeadm config images pull "--kubernetes-version=v$KUBERNETES_VERSION"

ctr --namespace=k8s.io image pull "ghcr.io/kube-vip/kube-vip:v$KUBEVIP_VERSION"
ctr --namespace=k8s.io image pull "ghcr.io/kube-vip/kube-vip-cloud-provider:v$KUBEVIP_CLOUD_PROVIDER_VERSION"

curl -fsSL "https://github.com/flannel-io/flannel/releases/download/v$FLANNEL_VERSION/kube-flannel.yml" | gawk -f /dev/fd/3 3<<'AWK'
/^ *image:/ { seen[$2]++ }
END { for (img in seen) system("ctr --namespace=k8s.io image pull " img) }
AWK

install -m u=rwx,go=rx /dev/fd/0 /usr/local/bin/kube-vip <<EOF
#!/usr/bin/env bash
exec ctr --namespace=k8s.io run --rm --net-host ghcr.io/kube-vip/kube-vip:v$KUBEVIP_VERSION vip /kube-vip "\$@"
EOF

install -m u=rw,go=r /dev/fd/0 /etc/profile.d/crictl.sh <<'EOF'
export CONTAINER_RUNTIME_ENDPOINT=/run/containerd/containerd.sock
export IMAGE_SERVICE_ENDPOINT=/run/containerd/containerd.sock
EOF

install -m u=rw,go=r /dev/fd/0 /etc/profile.d/kubeconfig.sh <<'EOF'
export KUBECONFIG=/etc/kubernetes/admin.conf
EOF

sync
