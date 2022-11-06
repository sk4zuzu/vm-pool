#!/usr/bin/env ksh

set -o errexit -o nounset -o pipefail
set -x

pkg_add \
    bash bat \
    ca-certificates curl \
    gawk git \
    htop \
    jq \
    mc mozilla-rootcerts-openssl \
    nmap \
    python39 \
    ripgrep \
    sudo \
    tcpdump \
    vim

ln -s /usr/pkg/bin/python3.9 /usr/bin/python3

sync
