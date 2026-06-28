#!/bin/sh
# Assemble and install a keyd config for the AT keyboard.
#
# keyd requires all bindings for a device to live in a single .conf file,
# so this script concatenates the base config with any requested fragments.
#
# Usage (run as root or with sudo):
#   install.sh [fragment...]
set -eu

DIR=$(cd "$(dirname "$0")" && pwd)

{
    cat "${DIR}/default.conf"
    for frag in "$@"; do
        printf '\n'
        cat "${DIR}/${frag}"
    done
} | install -Dm644 /dev/stdin /etc/keyd/builtin-keyboard.conf

keyd.rvaiya reload
