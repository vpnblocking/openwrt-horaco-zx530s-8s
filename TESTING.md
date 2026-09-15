# Validation of the current port

The final build is `zx530-controls1-443e267bdb92`, with LEDs and the reset declaration. The owner reported correct operation after the final installation instructions. The following tests were collected across development and installed builds on one RTL9303 revision B unit; they were not all repeated on the final binary.

## Results

| Area | Result and scope |
| --- | --- |
| Initramfs | Booted through original U-Boot and TFTP |
| Flash installation | Validation and installation succeeded; original boota booted OpenWrt |
| Final combined build | Owner confirmed correct operation after receiving controls1 installation instructions |
| Storage | SquashFS root and writable JFFS2 overlay; reboot persistence confirmed |
| Upgrade retention | Post-upgrade hostname, network configuration and overlay supplied; retention confirmed |
| MAC | Original per-device MAC retrieved via BDINFO NVMEM |
| Eight-port mapping | Each physical port checked at 1G with three successful ping replies |
| 10G | Links observed on ports 2,5,6,7,8 with tested passive DACs |
| L2 / VLANs | Access ports, tagged trunks and mixed native/tagged operation exercised |
| Jumbo frames | MTU9000 used in a configured test network |
| Throughput | Near-10G iperf3 forwarding and low switch CPU use reported by the owner |
| Stability | More than four hours uptime captured during L2 use; residual counters reported stable |
| Port LEDs | Log showed set0 configured; owner confirmed correct port illumination |
| Reset input | Internal GPIO5 observed 1→0→1 on press/release; standard active-low mapping integrated |
| SYS / PWR | SYS blinking and PWR continuously lit reported |
| Optional UI | LuCI installed and used separately; not embedded in minimal defaults |

Throughput is an owner report, not an archived controlled benchmark. Low CPU use is consistent with hardware L2 forwarding; no claim is made that every feature/flow is accelerated. Private VLANs and MTU settings used in tests are not part of the image defaults.

## Final offline checks

Compilation completed successfully. Both image headers, CRCs, LZMA streams, MIPS entry trampolines and memory bounds were checked. Compiled DTBs contain the correct board identity, SFP/PCS/GPIO maps, flash layout, NVMEM MAC, LED array and active-low GPIO5 KEY_RESTART declaration.

The installed kernel ends below the original boota buffer at 0x81000000; initramfs uses transfer address 0x82000000. SquashFS and initramfs contents, generic defaults and upgrade scripts were checked. Metadata identifies horaco,zx530s-8s and the image fits the 12 MiB firmware region. The source patch applies to the pinned commit.

## Coverage limits

- No destructive factory-reset action was explicitly reported. The physical input and polarity are confirmed and the standard handler is included.
- Stock recovery is documented but not physically exercised.
- Other revisions, all module/DAC types, 2.5G and 10G on ports 1,3,4 are not independently validated.
- Exact LED colors, blink timing and every speed/port combination were not recorded separately.
- SYS/PWR function as observed, but explicit SYS failsafe/upgrade indication is not implemented or claimed.
- STP/LAG, multicast snooping and formal VLAN isolation tests were not exhaustively performed.
- No maximum module power or L3/PPPoE performance claim is made.

During development, RX-idle PCS timeouts and RTL8231/device-link warnings occurred alongside working links. Startup could take tens of seconds; allow 90 seconds before diagnosing missing management. The observations do not establish that every future warning is harmless.

Independent reports should state hardware/bootloader revision, modules, ports, firmware revision and results. Remove credentials, serial numbers, MAC addresses and private network details from public logs.
