#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

systemctl mask NetworkManager-wait-online.service

sync
