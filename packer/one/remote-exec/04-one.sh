#!/usr/bin/env bash

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

apt-get -q update -y

policy_rc_d_disable

apt-get -q install -y \
    bash-completion bison \
    debhelper default-jdk \
    flex \
    javahelper \
    libcurl4 libcurl4-openssl-dev libmysql++-dev \
    libsqlite3-dev libssl-dev libsystemd-dev libws-commons-util-java \
    libvncserver-dev libxml2-dev libxmlrpc-c++8-dev libxslt1-dev \
    nodejs npm \
    postgresql-server-dev-all python3-setuptools \
    ruby \
    scons

apt-get -q install -y \
    libczmq-dev \
    pciutils \
    rsync

apt-get -q install -y \
    arptables \
    bridge-utils \
    ebtables \
    iproute2 iptables \
    nftables \
    tcpdump

apt-get -q install -y \
    dnsmasq \
    libvirt-clients \
    libvirt-daemon-system \
    qemu-kvm qemu-utils

apt-get -q install -y \
    genisoimage \
    libnbd-bin

policy_rc_d_enable

apt-get -q clean

sync
