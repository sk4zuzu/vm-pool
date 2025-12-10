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
    python313 py313-pip \
    ripgrep \
    sudo \
    tcpdump \
    vim

ln -s /usr/pkg/bin/python3.13 /usr/bin/python3
ln -s /usr/pkg/bin/pip3.13 /usr/bin/pip3

sync
