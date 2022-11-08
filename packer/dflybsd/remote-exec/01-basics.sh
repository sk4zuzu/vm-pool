#!/usr/bin/env sh

set -o errexit -o nounset -o pipefail
set -x

pkg install -y \
    bash bat \
    htop \
    jq \
    mc \
    nmap \
    python3 \
    ripgrep \
    sudo \
    vim

sync
