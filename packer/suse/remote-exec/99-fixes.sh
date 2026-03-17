#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

#zypper --non-interactive install -y systemd-networkd systemd-resolved
#
#ln -sf /usr/lib/systemd/system/systemd-networkd.service /etc/systemd/system/network.service
#ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
#systemctl enable systemd-networkd.service systemd-resolved.service
#systemctl mask systemd-networkd-wait-online.service
#
#systemctl disable wicked.service wickedd.service
#systemctl mask wicked.service wickedd.service
#
#cat >/etc/cloud/cloud.cfg.d/99_network.cfg <<'YAML'
#system_info:
#  network:
#    renderers: ['networkd']
#YAML

rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /var/lib/wicked/*.xml

sync
