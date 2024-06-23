#!/usr/bin/env bash

: "${REPO:=https://repo-default.voidlinux.org/current/musl/}"
: "${ARCH:=x86_64-musl}"

set -o errexit -o nounset -o pipefail
set -x

sfdisk /dev/vda <<< ';'
mkfs.ext4 /dev/vda1
mount /dev/vda1 /mnt/

install -d /mnt/var/db/xbps/keys/
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

XBPS_ARCH="$ARCH" xbps-install -Sy -r /mnt -R "$REPO" \
    base-system \
    cdrtools \
    gawk grub \
    htop \
    jq \
    mc \
    neovim \
    shinit socklog-void \
    tcpdump

install -o 0 -g 0 -m u=rw,go=r /tmp/00-shinit.sh /mnt/usr/libexec/shinit/provider/vm-pool

xchroot /mnt/ /bin/bash -es <<'XCHROOT'
install -o 0 -g 0 -m u=rw,go= /dev/fd/0 /etc/sudoers.d/wheel <<'EOF'
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF

useradd -md /home/void -g wheel -s /bin/bash void
passwd void <<'EOF'
asd
asd
EOF

passwd root <<'EOF'
asd
asd
EOF
chsh -s /bin/bash root

install -o 0 -g 0 -m u=rw,go=r /dev/fd/0 /etc/bash/bashrc.d/prompt.sh <<'EOF'
export PS1='\h:\w\$ '
EOF

for SV in nanoklogd shinit socklog-unix sshd; do
    ln -s "/etc/sv/$SV" /etc/runit/runsvdir/default/
done

install -o 0 -g 0 -m u=rw,go=r /dev/fd/0 /etc/fstab <<'EOF'
/dev/vda1 /    ext4  rw,relatime           0 0
tmpfs     /tmp tmpfs defaults,nosuid,nodev 0 0
EOF

grub-install /dev/vda

xbps-reconfigure -fa
XCHROOT

sync
