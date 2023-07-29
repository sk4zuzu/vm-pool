#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add \
    bash bat \
    curl \
    e2fsprogs-extra \
    fd \
    gawk \
    gzip \
    htop \
    iftop iproute2 iptables \
    jq \
    make mc \
    nethogs ngrep nmap nmap-ncat \
    openssh-client \
    pv python3 \
    ripgrep \
    sudo \
    tar tcpdump tshark \
    vim \
    xfsprogs-extra \
    zip \
    zstd

sync
