#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

zypper --non-interactive --gpg-auto-import-keys addrepo \
    "https://download.opensuse.org/distribution/${DISTRO,,}/$VERSION/repo/oss/" repo-oss

zypper --non-interactive --gpg-auto-import-keys addrepo \
    "https://download.opensuse.org/distribution/${DISTRO,,}/$VERSION/repo/non-oss/" repo-non-oss

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
