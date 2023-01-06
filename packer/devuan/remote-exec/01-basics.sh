#!/usr/bin/env bash

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

cat >>/etc/apt/sources.list <<'EOF'
deb http://deb.devuan.org/merged chimaera          main
deb http://deb.devuan.org/merged chimaera-updates  main
deb http://deb.devuan.org/merged chimaera-security main
EOF

apt-get -q update -y

policy_rc_d_disable

apt-get -q install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

apt-get -q install -y --no-install-recommends \
    gawk \
    htop \
    iftop iproute2 \
    jq \
    mc \
    net-tools netcat nethogs nmap \
    pv \
    vim

apt-get -q install -y \
    cloud-init

policy_rc_d_enable

apt-get -q clean

sync
