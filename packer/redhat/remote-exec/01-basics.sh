#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

subscription-manager register \
    --username "$SUBSCRIPTION_USERNAME" \
    --password "$SUBSCRIPTION_PASSWORD" \
    --force

subscription-manager repos \
    --enable "codeready-builder-for-rhel-$RELEASE-x86_64-rpms"

dnf install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-$RELEASE.noarch.rpm"

dnf repolist enabled

dnf makecache

dnf update -y

dnf install -y \
    curl \
    htop \
    iftop iproute \
    jq \
    mc \
    net-tools netcat nethogs nmap \
    pv \
    vim \
    wget

sync
