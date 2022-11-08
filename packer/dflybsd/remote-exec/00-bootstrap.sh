#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

fdisk -I -B /dev/vbd0

disklabel -w -r /dev/vbd0s1
disklabel -r /dev/vbd0s1 >/tmp/vbd0s1

cat >>/tmp/vbd0s1 <<EOF
a: *  * 4.2BSD
EOF

disklabel -R /dev/vbd0s1 /tmp/vbd0s1
disklabel -B /dev/vbd0s1

newfs /dev/vbd0s1a
mount /dev/vbd0s1a /mnt/

cpdup -o -u /               /mnt/
cpdup -o -u /etc.hdd/       /mnt/etc/
cpdup -o -u /usr/local/etc/ /mnt/usr/local/etc/

rm -rf /mnt/*.catalog \
       /mnt/*.html \
       /mnt/*.ico \
       /mnt/autorun.* \
       /mnt/etc.hdd/

find /var/ -type d -print0 \
| sort -zr \
| xargs -0 -I{} install -d /mnt/{}

(cd /mnt/var/log/
 touch auth.log cron daemon messages security)

cat >/mnt/boot/loader.conf <<EOF
vfs.root.mountfrom="ufs:/dev/vbd0s1a"
EOF

cat >/mnt/etc/fstab <<EOF
/dev/vbd0s1a / ufs rw 1 1
EOF

cat >/mnt/etc/rc.conf <<EOF
hostname=dflybsd
dhcp_client=dhcpcd
dhcpcd_enable=YES
ifconfig_vtnet0=dhcp
ip6addrctl=YES
ip6addrctl_policy=ipv4_prefer
sendmail_enable=NONE
sshd_enable=YES
syslogd_enable=YES
EOF

sed -i '' -f- /mnt/etc/ssh/sshd_config <<EOF
s/^#*PasswordAuthentication .*/PasswordAuthentication yes/
s/^#*PermitRootLogin .*/PermitRootLogin yes/
EOF

chroot /mnt/ sh -es <<EOF
echo -n 'asd' | pw usermod -n root -h 0
EOF

umount /mnt/

sync && reboot
