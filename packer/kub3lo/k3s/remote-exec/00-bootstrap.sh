#!/usr/bin/env ash

set -o errexit -o nounset -o pipefail
set -x

setup-hostname alpine

cat >/etc/network/interfaces <<'EOF'
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
EOF

cat >/etc/resolv.conf <<'EOF'
nameserver 1.1.1.1
EOF

rc-service networking start
rc-update add networking boot

RELEASE=$(head -n1 /etc/alpine-release | cut -d. -f-2)

cat >/etc/apk/repositories <<EOF
http://dl-cdn.alpinelinux.org/alpine/v$RELEASE/main
http://dl-cdn.alpinelinux.org/alpine/v$RELEASE/community
EOF

apk --no-cache add bash openssh openssh-server-pam
echo PermitRootLogin yes >>/etc/ssh/sshd_config
rc-service sshd start
rc-update add sshd

passwd root <<'EOF'
asd
asd
asd
EOF

sync
