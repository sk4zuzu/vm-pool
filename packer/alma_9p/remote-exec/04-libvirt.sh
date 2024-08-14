#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

dnf install -y \
    bridge-utils \
    dnsmasq \
    libvirt \
    libvirt-client \
    libvirt-daemon-kvm \
    qemu-kvm

systemctl disable dnsmasq

tee -a /etc/libvirt/qemu.conf <<EOF
user = "root"
group = "root"
security_driver = "none"
EOF

systemctl start libvirtd

virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images/
virsh pool-autostart default

systemctl stop libvirtd

sync
