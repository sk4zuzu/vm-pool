#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add \
    bash bat \
    curl \
    fd \
    gzip \
    htop \
    iftop iproute2 \
    jq \
    mc \
    nethogs nmap nmap-ncat \
    openssh-client \
    pv python3 \
    ripgrep \
    sudo \
    tar \
    vim \
    zip \
    zstd

sync
