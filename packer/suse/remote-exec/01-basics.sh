#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

SUSEConnect -r "$REGISTRATION_CODE"
SUSEConnect -p "PackageHub/$VERSION/x86_64"

zypper --non-interactive --gpg-auto-import-keys refresh

zypper --non-interactive install -y \
    gawk \
    htop \
    iftop iproute2 \
    jq \
    make mc \
    net-tools netcat nethogs nmap \
    pv \
    vim

sync
