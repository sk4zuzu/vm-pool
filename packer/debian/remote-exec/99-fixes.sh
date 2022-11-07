#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

systemctl disable --now resolvconf

rm -f /etc/resolv.conf

sync
