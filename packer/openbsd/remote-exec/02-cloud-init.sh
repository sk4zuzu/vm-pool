#!/usr/bin/env ksh

set -o errexit -o nounset -o pipefail
set -x

(install -d /var/tmp/cloud-init/
 cd /var/tmp/cloud-init/
 git clone https://github.com/canonical/cloud-init.git .
 ./tools/build-on-openbsd)

cat >'/etc/rc.local' <<'EOF'
#!/usr/bin/env ksh
set -o errexit
/usr/local/bin/cloud-init init -l
/usr/local/bin/cloud-init init
/usr/local/bin/cloud-init modules --mode config
/usr/local/bin/cloud-init modules --mode final
EOF

sync
