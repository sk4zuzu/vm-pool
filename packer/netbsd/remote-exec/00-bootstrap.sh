#!/usr/bin/env sh

: "${RELEASE:=$(uname -r)}"
: "${SETS:=base comp etc kern-GENERIC man misc modules rescue tests text}"
: "${PASSWORD:=asd}"

set -o errexit -o nounset -o pipefail
set -x

fdisk -vv -f -i              /dev/ld0
fdisk -vv -f -u -s 169/63 -0 /dev/ld0
fdisk -vv -f -a           -0 /dev/ld0

EDITOR="sed -i 's/ e:/ a:/'" disklabel -v -e /dev/ld0

newfs -V 4 -O 2 /dev/ld0a
mount /dev/ld0a /mnt/

for SET in $SETS; do
    tar --chroot -xpf "/amd64/binary/sets/$SET.tar.xz" -C /mnt/
done

(cd /mnt/dev/ && sh ./MAKEDEV all)

for DIR in kern/ proc/; do
    install -d "/mnt/$DIR"
done

cat >/mnt/etc/fstab <<'EOF'
/dev/ld0a /         ffs    rw,log 1 1
kernfs    /kern/    kernfs rw     0 0
procfs    /proc/    procfs rw     0 0
ptyfs     /dev/pts/ ptyfs  rw     0 0
EOF

chroot /mnt/ /bin/ksh -es <<EOF
cp /usr/mdec/boot /boot
installboot -v /dev/ld0a /usr/mdec/bootxx_ffsv2 /boot
fdisk -vv /dev/ld0
usermod -p \$(pwhash '$PASSWORD') root
EOF

cat >>/mnt/etc/login.conf <<EOF
default:\
    :path=/usr/bin /bin /usr/sbin /sbin /usr/X11R7/bin /usr/pkg/bin /usr/pkg/sbin /usr/local/bin:
EOF

cat >/mnt/etc/pkg_install.conf <<EOF
PKG_PATH=http://cdn.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/$RELEASE/All/
EOF

cat >>/mnt/etc/ssh/sshd_config <<'EOF'
PermitRootLogin yes
EOF

cat >>/mnt/etc/rc.conf <<'EOF'
hostname=netbsd
ifconfig_vioif0=dhcp
ip6addrctl=YES
ip6addrctl_policy=ipv4_prefer
no_swap=YES
postfix=NO
rc_configured=YES
sshd=YES
EOF

sync && reboot
