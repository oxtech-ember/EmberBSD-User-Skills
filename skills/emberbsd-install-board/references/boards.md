# Board media operations

Set `OS_SRC` to the selected OS checkout when available.
Discover its board and image instructions.

```sh
git -C "$OS_SRC" rev-parse HEAD
git -C "$OS_SRC" ls-files 'ember/boards/*' 'ember/image/*'
```

Otherwise read the current [OS board catalog](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards).
Read the exact board page for support evidence, loader offsets, boot layout, and eMMC exposure.
With available GitHub CLI, discover release assets.

```sh
gh release list --repo oxtech-ember/EmberBSD
gh release view "$RELEASE" --repo oxtech-ember/EmberBSD --json tagName,assets
```

Follow the selected release's download procedure.
Select an installed host hash command.

```sh
shasum -a 256 "$IMAGE"
sha256sum "$IMAGE"
sha256 -q "$IMAGE"
```

Compare the published digest.
Verify decompressed bytes against their documented digest.
Missing images or checksums block writing.
Do not substitute another project's release.
Keep declared development-image input provenance explicit.

Identify the exact medium and size.
Use `diskutil list` on macOS or `lsblk -o NAME,SIZE,MODEL,SERIAL,MOUNTPOINTS` on Linux.
Use the local disk manual on other hosts.
Check exact device and data-loss authorization.
Unmount the selected medium's filesystems.
Follow the board's writer and the host's documented `dd` options.
Set `IMAGE` to the verified uncompressed raw whole-disk image.

```sh
dd if="$IMAGE" of="$DISK" bs=1048576 && sync
```

Check the exit status.
Verify an exact image-sized read-back through the documented writer.
Preserve the image layout.
Loaders can lie outside partitions.
Use the documented vendor exposure method for onboard eMMC.

If the board supports Raspberry Pi Imager or balenaEtcher, use its documented procedure.
Inspect their actual interfaces.
Imager customization requires integrated
[`rpi_preseed`](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/etc/rc.d/rpi_preseed).
It removes the secret-bearing preseed after first boot.
Unsupported password hashes leave the account without a password.
Verify SSH-key access.
Read the actual console and sshd defaults.
Accept sign-in on the selected physical board.
No released signed OTA interface is assumed.
