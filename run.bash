#!/bin/bash
set -e

elf=elf-$$

adduser -D -G elves $elf -s /bin/elvish
cleanup() {
    trap - EXIT
    deluser --remove-home $elf
}
trap cleanup EXIT

cd /home/$elf
su $elf
