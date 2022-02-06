#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

apk --no-cache add haproxy

sync
