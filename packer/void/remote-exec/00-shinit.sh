#!/usr/bin/env bash

check() {
    :
}

load() {
    SHINIT_USER=void

    NAME=$(iso-read -i /dev/sr0 -e /meta-data -o /dev/fd/1 | jq -r '.hostname')
    KEYS=$(iso-read -i /dev/sr0 -e /meta-data -o /dev/fd/1 | jq -r '.keys')
    DATA=$(iso-read -i /dev/sr0 -e /user-data -o /dev/fd/1)
}
