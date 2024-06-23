#!/usr/bin/env bash

check() {
    :
}

load() {
    SHINIT_USER=void

    NAME=$(isoinfo -i /dev/sr0 -R -x /meta-data | jq -r '.hostname')
    KEYS=$(isoinfo -i /dev/sr0 -R -x /meta-data | jq -r '.keys')
    DATA=$(isoinfo -i /dev/sr0 -R -x /user-data)
}
