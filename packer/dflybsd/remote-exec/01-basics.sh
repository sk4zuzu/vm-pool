#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

pkg install -y \
    bash bat \
    gawk \
    jq \
    nmap \
    python3 \
    ripgrep \
    sudo \
    vim

sync
