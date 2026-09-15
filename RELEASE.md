# Final local build

Source base: `443e267bdb923ad32c4184ddd757744e5f07f1e4` plus the included patch.
Revision: `zx530-controls1-443e267bdb92`. Kernel: `6.18.44`.

This is the final combined LEDs/reset build, reported operating correctly by the owner. Earlier LED1/install builds are superseded for the source proposal. Binary files are not included in this source archive; the following identifies the separately generated local files.

## zx530s-8s-controls1-ram.bin

- Size: 5221897 bytes.
- SHA256: `7862ee9c09aa60fc9c7e6b334ddd02db09857aee4e1d2ac6f296eaf088c2b4c8`.
- CRC32: `3cf648ca`.

## zx530s-8s-controls1-sysupgrade.bin

- Size: 5505311 bytes.
- SHA256: `e1869055725fa4cdca988b2fc328f9d158775b64580c3f00f96db7f046c1c0d2`.
- CRC32: `fed8fc84`.

Initramfs transfer address is 0x82000000. Sysupgrade is for installation/upgrade from OpenWrt, not the stock web interface. Rebuilt files may differ: use their own checksums. Private configuration retained during upgrade belongs to the installed device, not these generic defaults.
