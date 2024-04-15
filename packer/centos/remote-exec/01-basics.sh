#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
yum install -y centos-release-scl-rh
yum install -y centos-release-qemu-ev
yum install -y centos-release-ceph-nautilus

install -o 0 -g 0 -m u=rw,go=r /dev/fd/0 /etc/yum.repos.d/libvirt-latest.repo <<'EOF'
[libvirt-latest]
name=CentOS-$releasever - LibVirt-Latest
baseurl=http://mirror.centos.org/centos/$releasever/virt/$basearch/libvirt-latest/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

yum install -y \
    ca-certificates curl \
    gpg \
    sudo \
    wget

yum install -y \
    iftop iproute2 \
    jq \
    htop \
    mc \
    net-tools netcat nethogs nmap \
    pv python3 \
    vim

yum install -y \
    NetworkManager

sync
