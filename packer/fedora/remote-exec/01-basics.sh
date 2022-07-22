#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

dnf install -y \
    ca-certificates curl \
    gpg \
    sudo \
    wget

dnf install -y \
    gawk \
    htop \
    iftop iproute \
    jq \
    mc \
    net-tools netcat nethogs nmap \
    pv \
    vim

install -d -o root -g fedora -m ug=rwx,o= /terraform{,/remote-exec}

sync
