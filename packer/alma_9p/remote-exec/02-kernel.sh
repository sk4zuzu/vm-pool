#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm

dnf --enablerepo=elrepo-kernel install -y kernel-ml

# dnf install -y git mock python3-pip rpmdevtools
#
# rpmdev-setuptree
#
# (install -d ~/rpmbuild/almalinux-git-utils/ && cd ~/rpmbuild/almalinux-git-utils/
#  git clone https://git.almalinux.org/almalinux/almalinux-git-utils.git . || git pull origin
#  python3 setup.py build && pip3 install .)
#
# (install -d ~/rpmbuild/kernel/ && cd ~/rpmbuild/kernel/
#  git clone -b a9 https://git.almalinux.org/rpms/kernel.git . || git pull origin
#  /usr/local/bin/alma_get_sources)
#
# (cd ~/rpmbuild/ && mv -f ~/rpmbuild/kernel/* .)
#
# gawk -i inplace -f- ~/rpmbuild/SOURCES/kernel-x86_64{,-debug}-rhel.config <<'EOF'
# /CONFIG_NET_9P/ { next }
# /CONFIG_9P/     { next }
# { print }
# ENDFILE {
#     print "CONFIG_NET_9P=m"
#     print "CONFIG_NET_9P_VIRTIO=m"
#     print "# CONFIG_NET_9P_XEN is not set"
#     print "CONFIG_NET_9P_RDMA=m"
#     print "# CONFIG_NET_9P_DEBUG is not set"
#     print "CONFIG_9P_FS=m"
#     print "CONFIG_9P_FSCACHE=y"
#     print "CONFIG_9P_FS_POSIX_ACL=y"
#     print "# CONFIG_9P_FS_SECURITY is not set"
# }
# EOF
#
# (cd ~/rpmbuild/SPECS/ && rpmbuild -bs kernel.spec)
#
# mkfs.xfs /dev/vdb && mount /dev/vdb /var/lib/mock/
#
# if ! (cd ~/rpmbuild/SRPMS/ && mock -r almalinux-9-x86_64 --rebuild kernel-*.el9.src.rpm); then
#     cat /var/lib/mock/almalinux-9-x86_64/result/build.log
#     exit 1
# else
#     mv /var/lib/mock/almalinux-9-x86_64/result/ ~/rpmbuild/
# fi
#
# (cd ~/rpmbuild/result/
#  SUFFIX=$(find . -type f -name 'kernel-core-*.el9.x86_64.rpm' | gawk -F- '{ print $3 "-" $4; exit }')
#  rpm -Uv --force kernel-{,core-,modules-}$SUFFIX)

cat >/etc/modules-load.d/9pnet_virtio.conf <<'EOF'
9pnet_virtio
EOF

sync
