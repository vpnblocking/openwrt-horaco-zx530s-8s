# HORACO ZX530S-8S: working OpenWrt port with LEDs and reset

I have a working OpenWrt port for the HORACO ZX530S-8S: Realtek RTL9303, 128 MiB RAM, 16 MiB SPI NOR and eight SFP+ ports. The final combined build is operating on my unit.

It boots from flash using the original bootloader, keeps the device MAC and has a persistent JFFS2 overlay. All eight ports were checked at 1G, and 10G links on ports 2/5/6/7/8. Access/trunk VLANs and jumbo frames were also exercised, with near-10G iperf3 traffic between hosts and low switch CPU use. That is a practical test report rather than a formal benchmark.

Port LEDs now illuminate correctly using the stock-derived hardware configuration. The front reset input was confirmed as internal GPIO5, active low, and the final build includes OpenWrt's standard reset handler. SYS blinks and PWR stays lit. I have not deliberately exercised the destructive factory-reset action.

The patch adds a DTS and image profile using existing OpenWrt drivers. Networking defaults are generic, without my private VLANs or MTU settings. The source archive contains build/install instructions, the test matrix and final local image hashes.

This is community support being prepared for upstream review, not an official OpenWrt release. Installation needs console access, TFTP boot and a verified backup off-device. Do not flash through the stock web interface. Stock recovery is documented but not physically tested.

Feedback from other owners is welcome: hardware/bootloader revision, module or DAC type, port and test result. Other revisions and all module/speed combinations have not been checked. Please remove credentials, serial numbers and private network details from logs.
