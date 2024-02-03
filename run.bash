#!/bin/bash
set -e

elf=elf-$$

nohup adduser -D -G elves $elf -s /bin/elvish > /dev/null
cleanup() {
    trap - EXIT
    nohup deluser --remove-home $elf > /dev/null
}
trap cleanup EXIT

cat /etc/notice
cd /home/$elf
if test -n "$1"; then
    printf '%s' "$1" > setup
    chown $elf setup
    chmod +x setup
fi
su $elf
