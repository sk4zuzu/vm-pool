#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

install -o 0 -g 0 -d /etc/apparmor.d/local/abstractions/

cat >/etc/apparmor.d/local/abstractions/libvirt-qemu <<'AA'
  /_shared/** rwk,
AA

sync
