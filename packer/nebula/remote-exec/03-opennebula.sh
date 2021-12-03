#!/usr/bin/env bash

: "${OPENNEBULA_VERSION:=6.2}"
: "${OPENNEBULA_TAG:=v6.2.0}"

policy_rc_d_disable() (echo "exit 101" >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)
policy_rc_d_enable()  (echo "exit 0"   >/usr/sbin/policy-rc.d && chmod a+x /usr/sbin/policy-rc.d)

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL https://downloads.opennebula.org/repo/repo.key | apt-key add -

tee /etc/apt/sources.list.d/opennebula.list <<< "deb https://downloads.opennebula.org/repo/$OPENNEBULA_VERSION/Ubuntu/$(lsb_release -rs) stable opennebula"

apt-get -q update -y

policy_rc_d_disable

apt-get -q install -y opennebula-node

policy_rc_d_enable

sync
