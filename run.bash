#!/bin/bash
set -e

elf=elf-$$

nohup adduser -D -G elves $elf -s /bin/elvish
cleanup() {
    trap - EXIT
    nohup deluser --remove-home $elf
}
trap cleanup EXIT

cat /etc/notice
cd /home/$elf
su $elf
