#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

pkg install -y bash gawk

cat >>/etc/rc.conf <<EOF
sshd_enable=YES
EOF

echo -n 'asd' | pw usermod -n root -h 0

gawk -i inplace -f- /etc/ssh/sshd_config <<'EOF'
BEGIN { update = "PermitRootLogin yes" }
/^[#\s]*PermitRootLogin\s/ { $0 = update; found = 1 }
{ print }
ENDFILE { if (!found) print update }
EOF

/etc/rc.d/sshd start

sync
