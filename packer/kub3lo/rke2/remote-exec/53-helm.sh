#!/usr/bin/env bash

: "${HELM_VERSION:=3.8.2}"

set -o errexit -o nounset -o pipefail
set -x

curl -fsSL "https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz" \
| tar -xz -f- --strip-components=1 -O linux-amd64/helm \
| install -m u=rwx,go=rx /dev/fd/0 "/usr/local/bin/helm-$HELM_VERSION"

ln -s "helm-$HELM_VERSION" /usr/local/bin/helm

sync
