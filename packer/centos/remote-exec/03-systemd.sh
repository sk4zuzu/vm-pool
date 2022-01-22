#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

yum install -y \
    systemd-networkd

systemctl enable systemd-networkd

install -o systemd-network -g systemd-network -m ug=rwx,o=rx -d /etc/systemd/network/

sync
