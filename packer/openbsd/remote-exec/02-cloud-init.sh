#!/usr/bin/env ksh

: "${CLOUD_INIT_RELEASE:=24.4.1}"

set -o errexit -o nounset -o pipefail
set -x

pkg_add \
    bash \
    dmidecode \
    py3-configobj py3-jinja2 py3-jsonschema py3-netifaces py3-oauthlib py3-requests py3-setuptools py3-yaml \
    sudo--

(install -d /var/tmp/cloud-init/
 cd /var/tmp/cloud-init/
 git clone -b "$CLOUD_INIT_RELEASE" https://github.com/canonical/cloud-init.git .
 ./tools/build-on-openbsd)

cat >/etc/rc.local <<'EOF'
#!/usr/bin/env ksh
set -o errexit
/usr/local/bin/cloud-init init -l
/usr/local/bin/cloud-init init
/usr/local/bin/cloud-init modules --mode config
/usr/local/bin/cloud-init modules --mode final
EOF

sync
