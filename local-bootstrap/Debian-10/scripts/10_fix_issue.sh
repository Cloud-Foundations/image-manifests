#! /bin/bash --posix

set -eux
set -o pipefail

. /usr/lib/os-release
echo -E "Debian Linux $VERSION kernel v\r \m \n \l" > "/etc/issue"
