#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

systemctl mask systemd-networkd-wait-online.service

sync
