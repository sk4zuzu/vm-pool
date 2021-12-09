#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add \
    openssh-client curl \
    vim mc htop \
    iproute2 nmap nmap-ncat \
    iftop nethogs pv \
    jq

sync
