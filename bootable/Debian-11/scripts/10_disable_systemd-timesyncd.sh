#! /bin/bash --posix

set -eux
set -o pipefail

if [ -e /etc/systemd/system/systemd-timesyncd.service ]; then
    ls -Fl /etc/systemd/system/systemd-timesyncd.service
fi
systemctl disable systemd-timesyncd
