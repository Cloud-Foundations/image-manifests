#! /bin/bash --posix

set -eux
set -o pipefail

. /usr/lib/os-release
# Bullseye does not (yet?) set VERSION
: ${VERSION:="11 (bullseye)"}
echo -E "Debian Linux $VERSION kernel v\r \m \n \l" > "/etc/issue"
