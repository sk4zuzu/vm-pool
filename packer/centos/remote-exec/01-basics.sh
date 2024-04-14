#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
yum install -y centos-release-scl-rh
yum install -y centos-release-qemu-ev
yum install -y centos-release-ceph-nautilus

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
