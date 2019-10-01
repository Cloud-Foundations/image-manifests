#! /bin/bash --posix

set -x

# For debugging.
env
ls -lF /proc/self/fd
tty

apt-cache --names-only search \
	  'linux-image-[[:digit:].-]+-686$'

main="$(apt-cache --names-only search \
	  'linux-image-[[:digit:].-]+-686$' |\
          awk '{print $1}' | sort -V | tail -n 1)"

echo "Installing: $main"
apt-get -q -y --force-yes --no-install-recommends install "$main" || exit

# This both lists the contents and verifies that they were created, despite
# ignoring potential errors because a boot loader was not installed.
ls -lF /boot /lib/modules
