#! /bin/bash --posix

set -eux
set -o pipefail

# Grab site-specific variables for build environment.
. /etc/environment.build

ls -lF /boot
ls -lFR /usr/lib/ISOLINUX /usr/lib/PXELINUX  # HACK.

mv /usr/lib/ISOLINUX/isolinux.bin /
mv /usr/lib/PXELINUX/pxelinux.0 /
ln /pxelinux.cfg/default /isolinux.cfg
rm -f /initrd.img* /vmlinuz*
mv /boot/initrd.img-* /initrd.img
mv /boot/vmlinuz-* /vmlinuz

# Unpack initrd.
mkdir /initrd.root
(cd /initrd.root; \
 gunzip < /initrd.img | cpio -i --make-directories --numeric-uid-gid --preserve-modification-time)

# Install installer.
get-url "$dominator_components_directory/installer.tar.gz" - |\
  tar -C /initrd.root -xpz
ls -Fl /initrd.root/usr/local/sbin/installer
sha512sum /initrd.root/usr/local/sbin/installer

# Install busybox.
mkdir /newbin
busybox --install -s /newbin
mv /bin/busybox /initrd.root/bin
for i in $(ls /newbin); do
    [ -e "/initrd.root/bin/$i" ] || mv "/newbin/$i" "/initrd.root/bin"
done
mkdir -p /initrd.root/etc/udhcpc
mv /usr/share/doc/busybox-static/examples/udhcp/simple.script \
   /initrd.root/etc/udhcpc/default.script

# Install libraries needed for DNS lookups (idiotic glibc legacy lives on).
ln /lib/x86_64-linux-gnu/libnss_dns* /lib/x86_64-linux-gnu/libresolv* \
   /initrd.root/lib/x86_64-linux-gnu
echo 'hosts: dns' > /initrd.root/etc/nsswitch.conf

cp -a /initrd.overwrite/. /initrd.root

# Repackage initrd.
rm /initrd.img
(cd /initrd.root; find . | sort | cpio -o -H newc | gzip --best > /initrd.img)
