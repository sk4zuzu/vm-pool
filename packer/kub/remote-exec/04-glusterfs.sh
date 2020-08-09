#!/usr/bin/env bash

: ${GLUSTERFS_VERSION_MAJOR:=7}
: ${GLUSTERFS_CLIENT_VERSION:=${GLUSTERFS_VERSION_MAJOR}.7}
: ${GLUSTERFS_CLIENT_VERSION_APT:=${GLUSTERFS_CLIENT_VERSION}-ubuntu1~bionic2}

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

add-apt-repository -y ppa:gluster/glusterfs-${GLUSTERFS_VERSION_MAJOR}

apt-get -q update -y

policy_rc_d_disable

apt-get -q install -y \
    glusterfs-client="${GLUSTERFS_CLIENT_VERSION_APT}"

policy_rc_d_enable

apt-get -q clean

sync

# vim:ts=4:sw=4:et:syn=sh:
