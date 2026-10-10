# Install on boards: microSD and eMMC

Supported boards and their confirmed boundaries are listed per board in the
OS repository: [boards directory](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards)
(Raspberry Pi 5, Compute Module 5, Orange Pi Zero 3W and Zero 4,
Raspberry Pi Zero 2 W, ESP32-S31). Match the image to the board family and
follow that board page for loader and layout specifics.

## Obtain and verify the image

1. Take the image and its SHA256 from the EmberBSD repository's published
   release or its README instructions. If no image is published for the board,
   report that instead of substituting another project's image.
2. Verify the checksum on the host before writing.
3. Do not repartition or modify project-built images by hand. Allwinner A733
   boards keep loader areas at fixed offsets and a shifted partition layout;
   blind repartitioning overwrites boot0 and makes the card unbootable.

## Write the medium

Identify the target medium by exact identity and size using the host's disk
listing tool before writing; writing to the wrong disk destroys its data.
Writers, in order of preference:

- **Raspberry Pi Imager** on boards it supports: select the EmberBSD image,
  and use the OS customization so the first boot applies hostname, user,
  SSH keys and Wi-Fi. EmberBSD reads the Imager preseed file
  (`rpi-preseed.toml`) from the boot partition.
- **balenaEtcher** or **dd** for a plain image write. Uncompressed image
  files or verified decompression only; re-verify the checksum after any
  local decompression.

Compute Module 5 eMMC is written through rpiboot: the tool exposes the
module's eMMC as a USB mass-storage device on the host, after which the same
writer applies. Use the module-specific documentation; removable-card
settings do not apply to eMMC.

## First boot

- With Imager customization the system applies the preseed on first boot and
  removes the file, which contains the Wi-Fi passphrase.
- Password hashes that NetBSD `crypt(3)` cannot check (sha256crypt, yescrypt)
  are not applied; such accounts have no password. Distribute the SSH key and
  sign in with it.
- Public images ship no default password. sshd stays off until the preseed
  enables it; otherwise set up over the serial console first.

## After installation

Application setup belongs to `emberbsd-user-guide`. Operating-system updates
use the project's signed OTA channel as it becomes available; do not
overwrite a running system's partitions by hand.
