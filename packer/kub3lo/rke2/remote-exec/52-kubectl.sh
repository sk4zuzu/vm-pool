#!/usr/bin/env bash

: "${KUBECTL_VERSION:=1.23.7}"

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL "https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl" \
| install -m u=rwx,go=rx /dev/fd/0 "/usr/local/bin/kubectl-$KUBECTL_VERSION"

ln -s "kubectl-$KUBECTL_VERSION" /usr/local/bin/kubectl

sync
