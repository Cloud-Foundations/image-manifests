#! /bin/bash --posix

set -eux
set -o pipefail

# Grab site-specific variables for build environment.
. /etc/environment.build

readonly dir='/tmp/subd-unpack'

rm -rf "$dir" || exit
mkdir -p "$dir" || exit
get-url "$dominator_components_directory/subd.tar.gz" - | tar -C "$dir" -xz

"$dir/install" || exit
rm -rf "$dir"

# Ensure clean exit if we got this far.
exit 0
