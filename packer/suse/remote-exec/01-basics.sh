#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

SUSEConnect -r "$REGISTRATION_CODE"
SUSEConnect -p "sle-module-legacy/$VERSION/x86_64"
SUSEConnect -p "sle-module-desktop-applications/$VERSION/x86_64"
SUSEConnect -p "sle-module-development-tools/$VERSION/x86_64"
SUSEConnect -p "PackageHub/$VERSION/x86_64"

zypper --non-interactive --gpg-auto-import-keys refresh

zypper --non-interactive install -y \
    bridge-utils \
    gawk git \
    htop \
    iftop iproute2 \
    jq \
    make mc \
    net-tools netcat nethogs nftables nmap \
    pv \
    vim

sync
