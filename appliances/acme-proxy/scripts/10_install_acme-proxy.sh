#! /bin/sh

# Grab site-specific variables for build environment.
. /etc/environment.build

#get-url "$golib_components_directory/acme-proxy" - \
#	> /usr/local/sbin/acme-proxy
cp -p /n/binaries/golib/acme-proxy /usr/local/sbin/acme-proxy
chmod a+rx /usr/local/sbin/acme-proxy

mkdir -p /var/log/acme-proxy
chown acme-proxy /var/log/acme-proxy
