#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

dnf install -y oracle-epel-release-el8

dnf install -y \
    ca-certificates curl \
    gpg \
    htop \
    iftop iproute \
    jq \
    mc \
    net-tools netcat nethogs nmap \
    pv \
    sudo \
    vim \
    wget

dnf update -y

sync
