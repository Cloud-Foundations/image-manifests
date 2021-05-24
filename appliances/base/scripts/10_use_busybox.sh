#!/bin/bash
set -x

if [ -L /etc/localtime ]; then
    mv /etc/localtime /tmp
    cp -p /tmp/localtime /etc
    rm /tmp/localtime
fi

mkdir /etc/udhcpc
mv /usr/share/doc/busybox-static/examples/udhcp/simple.script /etc/udhcpc/default.script
mkdir /newbin
# The following breaks if /bin is a symlink /usr/bin, so iterate.
#/bin/busybox --install -s /newbin
for cmd in $(busybox --list); do
    ln -s busybox "/newbin/$cmd"
done
cp -p /bin/generic-packager /newbin

echo -e '#! /bin/sh\ntrue' > /newbin/apt-get
ln /newbin/apt-get /newbin/dpkg-query
chmod a+x /newbin/apt-get

mv /bin/busybox /newbin

mv /bin /oldbin
/oldbin/mv /newbin /bin

rm -rf /oldbin /tests
