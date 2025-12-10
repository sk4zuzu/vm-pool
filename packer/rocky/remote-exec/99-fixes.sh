#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

>/etc/resolv.conf

sync
