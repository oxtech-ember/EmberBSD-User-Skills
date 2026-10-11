# Board media installation

Read the exact page in [the OS board catalog](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards)
for support evidence, loader offsets, boot layout and eMMC exposure procedure.
Discover artifacts through current releases when GitHub CLI is available:

```sh
gh release list --repo oxtech-ember/EmberBSD
gh release view "$RELEASE" --repo oxtech-ember/EmberBSD --json tagName,assets
```

Follow the selected release/README download procedure. For SHA256, select an
installed host command: `shasum -a 256 "$IMAGE"`, `sha256sum "$IMAGE"`, or
`sha256 -q "$IMAGE"`. Compare the published digest; verify decompressed bytes
against their documented digest. Missing image/checksum blocks writing. Never
substitute another project's release; declared development-image inputs retain
their own provenance.

Identify exact medium and size: `diskutil list` on macOS,
`lsblk -o NAME,SIZE,MODEL,SERIAL,MOUNTPOINTS` on Linux, or local disk manuals
elsewhere. Check device/data-loss authorization, unmount its filesystems, then follow the
board's writer. For `dd`, `IMAGE` must be the verified uncompressed raw
whole-disk image, not a compressed archive or qcow2. Use the host's documented `dd`:

```sh
dd if="$IMAGE" of="$DISK" bs=1048576 && sync
```

Check exit status and exact image-sized read-back with the documented writer.
Preserve image layout: loaders may sit outside partitions. Use onboard eMMC's
documented vendor exposure method before selecting its host disk.

Raspberry Pi Imager/balenaEtcher are alternatives where supported; do not invent
their CLI. Imager customization requires image integration of
[`rpi_preseed`](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/etc/rc.d/rpi_preseed).
It removes the secret-bearing preseed after first boot. Unsupported password
hashes leave the account without a password: verify SSH-key access. Read actual
console/sshd defaults and accept sign-in on the selected board. For OS updates,
discover the current procedure; no released signed OTA interface is assumed.
