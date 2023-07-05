#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

RELEASE=$(awk -F: '/^CPE_NAME=/{print$5}' /etc/os-release)

subscription-manager register \
    --username "$SUBSCRIPTION_USERNAME" \
    --password "$SUBSCRIPTION_PASSWORD" \
    --auto-attach \
    --force

subscription-manager repos \
    --enable codeready-builder-for-rhel-$RELEASE-x86_64-rpms

dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$RELEASE.noarch.rpm

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
