#!/bin/sh
set -eu
[ "$(cat /tmp/sysinfo/board_name)" = 'horaco,zx530s-8s' ]
grep -q '^tmpfs / tmpfs ' /proc/mounts || {
    echo 'Run from the OpenWrt recovery initramfs.' >&2
    exit 1
}
dest=/tmp/zx530-backup
[ ! -e "$dest" ] || { echo "$dest already exists; preserve it before repeating." >&2; exit 1; }
mkdir "$dest"
for label in loader bdinfo sysinfo jffs2-cfg jffs2-log firmware oeminfo; do
    part=$(awk -v label="\"$label\"" '$4==label {gsub(":", "", $1); print $1}' /proc/mtd)
    [ -n "$part" ] && [ -c "/dev/$part" ]
    dd if="/dev/$part" of="$dest/$label.bin" bs=65536
done
cat /proc/mtd > "$dest/partitions.txt"
cat /sys/class/net/eth0/address > "$dest/mac.txt"
cd "$dest"
sha256sum ./*.bin > SHA256SUMS
cd /tmp
tar -czf zx530-backup-before-install.tar.gz zx530-backup
sha256sum /tmp/zx530-backup-before-install.tar.gz
echo 'Copy the archive off-device and verify it before installing. This copy is still in RAM.'
