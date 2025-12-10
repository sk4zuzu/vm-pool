#!/usr/bin/env ash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add \
    bash bat \
    curl \
    doas-sudo-shim \
    e2fsprogs-extra \
    fd \
    gawk gzip \
    htop \
    iftop iproute2 iptables \
    jq \
    lsblk \
    make mc \
    nethogs ngrep nmap nmap-ncat \
    openssh-client \
    pv python3 \
    ripgrep \
    tar tcpdump tshark \
    vim \
    xfsprogs-extra \
    zip zstd

sync
