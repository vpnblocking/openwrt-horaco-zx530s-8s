# Building the port

## Tested baseline

- OpenWrt commit: `443e267bdb923ad32c4184ddd757744e5f07f1e4`.
- Target: `realtek/rtl930x`; device: `horaco_zx530s-8s`.
- Kernel: `6.18.44`.
- Final local label: `zx530-controls1-443e267bdb92`.

The patch includes LEDs and reset. It applies to this pinned baseline; it is not represented as rebased onto the current upstream development branch.

## Build instructions

Use Linux with the normal [OpenWrt build dependencies](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem). Place this extracted package alongside the checkout:

```sh
git clone https://github.com/openwrt/openwrt.git
cd openwrt
git checkout -b codex/horaco-zx530s-8s 443e267bdb923ad32c4184ddd757744e5f07f1e4
git apply --check ../openwrt-submission/openwrt-zx530s-8s.patch
git apply ../openwrt-submission/openwrt-zx530s-8s.patch
cp ../openwrt-submission/config.seed .config
make defconfig
make -j4 download
make -j4
```

Use a clean checkout without a custom files/ overlay. Adjust paths and parallelism as appropriate. Core packages suffice for the minimal image; configure feeds separately for optional packages such as LuCI. No external networking driver repository is needed.

Outputs under `bin/targets/realtek/rtl930x/`:

- `openwrt-realtek-rtl930x-horaco_zx530s-8s-initramfs-kernel.bin`
- `openwrt-realtek-rtl930x-horaco_zx530s-8s-squashfs-sysupgrade.bin`

These commands reproduce the source/configuration basis, not byte-identical binaries. Timestamps, local version strings and tool environment affect hashes. Calculate checksums for your own files rather than reusing RELEASE.md values.

## LED and reset implementation

The original RTL9303_8XGE profile uses single-color scan mode with three LED positions in set0. Hardware LED0 is 0x0a01 (10G/link/activity), LED1 is 0x0aa8 (2.5G/1G/100M/link/activity), and LED2 is disabled. OpenWrt consumes the array in reverse order, so the DTS uses 0,0x0aa8,0x0a01, expressed with named macros. Omitting active-low reproduces the stock LED_ACTIVE setting. Port illumination was verified on the device.

The reset input was observed as 1 released, 0 pressed, 1 released. The DTS uses gpio0 offset5, GPIO_ACTIVE_LOW and KEY_RESTART. Existing gpio-button-hotplug support supplies the standard reset handler; no custom button script is shipped.
