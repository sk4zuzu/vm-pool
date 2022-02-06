#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

setup-keymap us us

setup-timezone -z UTC

apk --no-cache add openntpd
rc-service openntpd start
rc-update add openntpd

apk --no-cache add util-linux cloud-init
setup-cloud-init

(yes | setup-disk -v -m sys /dev/vda) || true

mount /dev/vda3 /mnt/
mount /dev/vda1 /mnt/boot/

mount -t proc /proc /mnt/proc/
mount --rbind /sys /mnt/sys/
mount --rbind /dev /mnt/dev/

cat >/mnt/etc/ssh/sshd_config <<EOF
AuthorizedKeysFile .ssh/authorized_keys
AllowAgentForwarding yes
AllowTcpForwarding yes
GatewayPorts yes
X11Forwarding yes
Subsystem sftp /usr/lib/ssh/sftp-server
PermitRootLogin yes
EOF

cat >/mnt/etc/cgconfig.conf <<EOF
mount {
  blkio   = /cgroup/blkio;
  cpu     = /cgroup/cpu;
  cpuacct = /cgroup/cpuacct;
  cpuset  = /cgroup/cpuset;
  devices = /cgroup/devices;
  freezer = /cgroup/freezer;
  memory  = /cgroup/memory;
  net_cls = /cgroup/net_cls;
}
EOF

cat >/mnt/etc/update-extlinux.d/override.conf <<EOF
default_kernel_opts="quiet rootfstype=ext4 cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1"
EOF

cat >>/mnt/etc/fstab <<EOF
cgroup /sys/fs/cgroup cgroup defaults 0 0
EOF

chroot /mnt/ /sbin/update-extlinux

sync
