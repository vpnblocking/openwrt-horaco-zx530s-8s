# Installation and recovery

Current working community port. Read the entire procedure before starting. Installation uses the original U-Boot console and an OpenWrt initramfs; **do not upload the sysupgrade image through the stock web interface**. No web factory image is validated.

## Flash layout

| Partition | Offset | Size | OpenWrt access |
| --- | --- | --- | --- |
| loader | 0x000000 | 0x0e0000 | Read-only |
| bdinfo | 0x0e0000 | 0x010000 | Read-only |
| sysinfo | 0x0f0000 | 0x010000 | Read-only |
| jffs2-cfg | 0x100000 | 0x100000 | Read-only |
| jffs2-log | 0x200000 | 0x100000 | Read-only |
| firmware (stock RUNTIME) | 0x300000 | 0xc00000 | Writable |
| oeminfo | 0xf00000 | 0x100000 | Read-only |

Only firmware is replaced. Kernel/rootfs/rootfs_data are derived partitions inside it. MTD numbers can change after installation: find partitions by name, not by an assumed number. Do not replace the loader or save a new boot environment.

## Boot the installation initramfs

Disconnect production uplinks and use a direct isolated connection to physical port 1. The tested setup used a 1G RJ45 SFP module; different modules may require different bootloader media settings. Use a local TFTP server at 192.168.150.5/24 and the console at 115200 baud. Rename the generated initramfs to `zx530-initramfs.bin` on the server.

Calculate the length and CRC32 of your exact initramfs on the host first:

```sh
python3 - <<'PY'
from pathlib import Path
import zlib
image = Path('zx530-initramfs.bin').read_bytes()
print('Bytes:', len(image), 'Hex size:', hex(len(image)))
print('CRC32:', f'{zlib.crc32(image):08x}')
PY
```

Reboot, interrupt autoboot with Esc, then:

```text
setenv autostart no
setenv ipaddr 192.168.150.6
setenv serverip 192.168.150.5
setenv netmask 255.255.255.0
setenv vlan
setenv nvlan
rtk network on
rtk 10g 0 fiber1g
rtk ext-devInit 0
rtk ext-pinSet 0 0
tftpboot 0x82000000 zx530-initramfs.bin
```

Verify transferred size and CRC32 against the exact file you built. Run `crc32 0x82000000 <actual_size_in_hex>` with a real size, not the placeholder. If correct, run `bootm 0x82000000`. Use 0x82000000 for initramfs: 0x81000000 can overlap decompression. The installed non-initramfs kernel was separately checked for the original boota buffer at 0x81000000.

The installation initramfs has a writable firmware partition. Booting it alone does not install OpenWrt. Keep all production links disconnected: defaults bridge all eight ports on VLAN1.

Allow 90 seconds for startup. Set the PC to 192.168.1.2/24; OpenWrt management defaults to 192.168.1.1/24. Check identity (`cat /tmp/sysinfo/board_name`), MAC, `/proc/mtd`, and `ubus call network.interface.lan status`. Set a temporary root password using `passwd`.

## Back up before installation

From the host, copy the included script:

```sh
scp -O backup-before-install.sh root@192.168.1.1:/tmp/
```

Modern OpenSSH may need `scp -O` because the minimal image supports classic SCP rather than SFTP. Run `sh /tmp/backup-before-install.sh` after transferring it to /tmp. Copy `/tmp/zx530-backup-before-install.tar.gz` OFF the switch, verify its SHA256 against the switch output and verify archive contents. It must contain seven partition images and their SHA256SUMS. A backup left only in /tmp will disappear on reboot.

To retrieve the archive from the host:

```sh
scp -O root@192.168.1.1:/tmp/zx530-backup-before-install.tar.gz .
```

Use sha256sum on Linux or shasum -a256 on macOS to compare the archive hash. Extract it and verify the seven images against the included SHA256SUMS.

Keep the backups private. Preserve the original backup as well if taking a newer copy. Do not distribute another unit's stock firmware, configuration or identity data in this source bundle.

## First installation

From the directory containing the generated image on the host:

```sh
scp -O openwrt-realtek-rtl930x-horaco_zx530s-8s-squashfs-sysupgrade.bin root@192.168.1.1:/tmp/zx530-sysupgrade.bin
```

On the switch, run `sha256sum /tmp/zx530-sysupgrade.bin`. Compare its SHA256 with the file on the build host, then:

```sh
sysupgrade -T /tmp/zx530-sysupgrade.bin
```

Proceed only if validation exits 0, the board matches and the off-device backup is verified. The following command writes firmware and reboots:

```sh
sysupgrade -n /tmp/zx530-sysupgrade.bin
```

Do not use -F to bypass a failed check. Keep power connected during flashing. Leave the original bootcmd/boota unchanged. Capture serial output.

After boot, verify `/rom` is SquashFS and `/overlay` is JFFS2 with an overlay root. The first boot may briefly use a temporary overlay before initialization completes. Confirm management and MAC, set a password, save a harmless configuration change, reboot and verify it persists. Later upgrades without -n should preserve supported configuration files; they do not automatically preserve packages installed after building the image.

## Subsequent upgrades

Transfer the matching sysupgrade image to /tmp/zx530-sysupgrade.bin, compare its SHA256 and run sysupgrade -T first. Preserve supported configuration with:

```sh
sysupgrade /tmp/zx530-sysupgrade.bin
```

Do not add -n when retaining configuration. Separately installed packages, including LuCI, are not automatically retained. Settings saved through UCI are persistent configuration; temporary ip link MTU changes are not.

## Front reset button

The final port uses the standard OpenWrt reset handler. In the pinned build, releasing with a reported duration below one second reboots; releasing after at least five seconds with an active overlay requests factory reset and reboot. This is no longer the GPIO-only diagnostic: a long press can erase configuration. No custom button behavior is shipped.

## Recovery to stock — documented, not physically tested

The loader and stock configuration partitions are preserved. Interrupt original U-Boot and boot the same installation initramfs via TFTP. Transfer only `firmware.bin` from YOUR verified pre-install backup to /tmp using SCP. Verify its size is 12582912 bytes and SHA256 matches your backup manifest. Check that the target partition is named firmware and is 12 MiB.

From the initramfs, the following restores only that region:

```sh
mtd write /tmp/firmware.bin firmware
```

If writing fails, do not force or reboot blindly. On success, locate the firmware MTD partition by name, hash its contents, and compare to the backup before rebooting. Do not restore the entire chip or another device's loader/identity. This recovery route depends on a functioning bootloader, console, RAM and network and has not yet been exercised physically.
