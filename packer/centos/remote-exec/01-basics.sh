#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"

yum install -y \
    ca-certificates \
    sudo wget gpg curl

yum install -y \
    pv \
    vim mc htop \
    net-tools iproute2 netcat nmap \
    iftop nethogs \
    jq

sync
