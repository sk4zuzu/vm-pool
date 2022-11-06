#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

pkg install -y \
    bat \
    curl \
    git \
    htop \
    jq \
    mc \
    nmap \
    python3 \
    ripgrep \
    sudo \
    tcpdump \
    vim

sync
