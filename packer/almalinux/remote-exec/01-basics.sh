#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

dnf install -y epel-release

dnf install -y \
    ca-certificates curl \
    gawk gpg \
    sudo \
    wget

dnf install -y \
    htop \
    iftop iproute \
    jq \
    mc \
    net-tools netcat nethogs nmap \
    pv \
    vim

sync
