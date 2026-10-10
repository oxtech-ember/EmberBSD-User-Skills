# Install on boards: cards and onboard storage

Per-board facts — supported models, loader placement, boot layout, onboard
eMMC procedure, confirmed boundaries — live with the OS in its
[boards directory](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards).
Read the page for the exact board before writing; this reference carries the
method common to all of them so it does not have to be re-derived.

## Obtain and verify the image

1. Take the image and its SHA256 from the EmberBSD repository's published
   release or its README instructions. If no image is published for the
   board, report that instead of substituting another project's image.
2. Verify the checksum on the host before writing, and again after any local
   decompression.
3. Use project-built images as-is. On several SoCs the boot loaders sit at
   fixed offsets outside the partitions; hand repartitioning or reformatting
   a project image overwrites them and makes the medium unbootable.

## Write the medium

Identify the target medium by exact identity and size with the host's disk
listing tool before writing; writing to the wrong disk destroys its data.
Writers, in order of preference:

- **Raspberry Pi Imager** where the board's boot flow allows it: select the
  EmberBSD image and fill in the OS customization (hostname, user, SSH key,
  Wi-Fi). EmberBSD applies the Imager preseed file from the boot partition on
  first boot when the image supports it.
- **balenaEtcher** or **dd** for a plain image write.

Removable cards are written directly. Modules with onboard eMMC are usually
exposed to the host as a USB mass-storage device by the vendor's utility or
board-specific procedure; follow the board page for it, then apply the same
writer. Removable-card firmware settings do not apply to onboard storage.

## First boot

- Where preseed is supported, the system applies it on first boot and then
  removes the file, which contains the Wi-Fi passphrase.
- Password hashes the target's `crypt(3)` cannot check are not applied; such
  accounts get no password. Distribute the SSH key and sign in with it.
- Public images ship no default password. sshd stays off until the preseed
  enables it; otherwise complete setup over the serial console first.

## After installation

Application setup belongs to `emberbsd-user-guide`. Operating-system updates
use the project's signed OTA channel as it becomes available; do not
overwrite a running system's partitions by hand.
