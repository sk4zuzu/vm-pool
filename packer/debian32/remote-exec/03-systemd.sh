#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

set -o errexit -o nounset -o pipefail
set -x

systemctl mask systemd-networkd-wait-online.service

sync
