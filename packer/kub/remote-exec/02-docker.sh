#!/usr/bin/env bash

: ${DOCKER_CE_VERSION:=18.09.9}
: ${DOCKER_CE_VERSION_APT:=5:${DOCKER_CE_VERSION}~3-0~ubuntu-bionic}
: ${CONTAINERD_IO_VERSION:=1.2.10}
: ${CONTAINERD_IO_VERSION_APT:=${CONTAINERD_IO_VERSION}-3}

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get -q update -y

policy_rc_d_disable

apt-get -q install -y \
    docker-ce{,-cli}="${DOCKER_CE_VERSION_APT}" \
    containerd.io="${CONTAINERD_IO_VERSION_APT}"

apt-mark hold \
    docker-ce{,-cli} \
    containerd.io

# setup "systemd" as cgroup driver
install -d /etc/docker/ && cat >/etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

policy_rc_d_enable

apt-get -q clean

systemctl start docker

sync

# vim:ts=4:sw=4:et:syn=sh:
