#!/usr/bin/env bash

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

apt-get -q update -y

policy_rc_d_disable

apt-get -q remove -y --purge \
    fwupd \
    snapd \
    unattended-upgrades

apt-get autoremove -y --purge

apt-get -q upgrade -y

apt-get -q install -y \
    bash bat \
    curl \
    e2fsprogs \
    gawk gzip \
    htop \
    iftop iproute2 \
    jq \
    make mc \
    nethogs nmap ncat \
    openssh-client \
    pv python3 \
    sudo \
    tar \
    vim \
    xfsprogs \
    zip zstd

policy_rc_d_enable

apt-get -q clean

sync
