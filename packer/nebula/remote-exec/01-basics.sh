#!/usr/bin/env bash

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

#gawk -i inplace -f- /etc/cloud/cloud.cfg <<'EOF'
#$1 == "apt_preserve_sources_list:" { $2 = "true"; found=1 }
#{ print }
#END { if (!found) print "apt_preserve_sources_list: true" >> FILENAME }
#EOF
#
#RELEASE=$(lsb_release -sc)
#
#cat >/etc/apt/sources.list <<EOF
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE main restricted
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE-updates main restricted
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE universe
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE-updates universe
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE multiverse
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE-updates multiverse
#deb mirror://mirrors.ubuntu.com/mirrors.txt $RELEASE-backports main restricted universe multiverse
#
#deb http://archive.ubuntu.com/ubuntu $RELEASE main restricted
#deb http://archive.ubuntu.com/ubuntu $RELEASE-updates main restricted
#deb http://archive.ubuntu.com/ubuntu $RELEASE universe
#deb http://archive.ubuntu.com/ubuntu $RELEASE-updates universe
#deb http://archive.ubuntu.com/ubuntu $RELEASE multiverse
#deb http://archive.ubuntu.com/ubuntu $RELEASE-updates multiverse
#deb http://archive.ubuntu.com/ubuntu $RELEASE-backports main restricted universe multiverse
#
#deb http://security.ubuntu.com/ubuntu $RELEASE-security main restricted
#deb http://security.ubuntu.com/ubuntu $RELEASE-security universe
#deb http://security.ubuntu.com/ubuntu $RELEASE-security multiverse
#EOF

apt-get -q update -y

policy_rc_d_disable

apt-get -q remove -y --purge \
    unattended-upgrades

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
    make mc \
    net-tools netcat-traditional nethogs nmap \
    pv \
    vim

apt-get -q install -y --no-install-recommends \
    libxml2-utils

policy_rc_d_enable

apt-get -q clean

sync
