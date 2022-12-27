#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

pacman --noconfirm -Sy \
    ca-certificates curl \
    gawk

pacman --noconfirm -Sy \
    htop \
    iftop iproute \
    jq \
    mc \
    net-tools netcat nethogs nmap \
    vim

sync
