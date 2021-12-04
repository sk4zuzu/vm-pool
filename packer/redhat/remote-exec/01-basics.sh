#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

subscription-manager register \
    --username "$SUBSCRIPTION_USERNAME" \
    --password "$SUBSCRIPTION_PASSWORD" \
    --auto-attach \
    --force

subscription-manager repos \
    --enable rhel-7-server-rpms \
    --enable rhel-7-server-extras-rpms \
    --enable rhel-server-rhscl-7-rpms

yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"

yum repolist enabled

yum makecache fast

yum update -y

yum install -y \
    curl \
    wget

yum install -y \
    pv \
    vim mc htop \
    net-tools iproute2 netcat nmap \
    iftop nethogs \
    jq

install -d -o root -g cloud-user -m ug=rwx,o= /terraform{,/remote-exec}

sync
