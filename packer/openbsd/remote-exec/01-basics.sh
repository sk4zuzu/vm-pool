#!/usr/bin/env ksh

set -o errexit -o nounset -o pipefail
set -x

pkg_add \
    bat \
    curl \
    fd \
    gawk git \
    htop \
    jq \
    mc \
    nmap \
    ripgrep \
    sudo-- \
    vim--no_x11

sync
