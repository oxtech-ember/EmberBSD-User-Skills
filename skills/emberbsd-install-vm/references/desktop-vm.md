# Desktop VM operations

Use an aarch64 guest.
Apple Silicon can use UTM/QEMU with HVF.
Other hosts require a documented QEMU emulation path and its limits.
Do not assume an x86-64 guest or bare-metal desktop port.

Set `OS_SRC` to the selected checkout when available.
Discover the actual image and host tools.

```sh
git -C "$OS_SRC" ls-files 'ember/image/*' 'sys/dev/fdt/docs/utm-framebuffer.md'
command -v qemu-img qemu-system-aarch64
qemu-system-aarch64 --version
qemu-system-aarch64 -machine help
```

Otherwise read the current [OS image sources](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/image).
If a published qcow2 and checksum are available, use them.
The OS development image declares verified NetBSD 11 base sets and accepted EmberBSD components.
It is separate from a complete general release.
Use its builder only for a requested development image.

Verify the hash before offline inspection.

```sh
qemu-img info --output=json "$IMAGE"
qemu-img check "$IMAGE"
```

Use the owning launch recipe.
Check aarch64 `virt`, matching UEFI, VirtIO disk/network, serial console, CPU, RAM, and backend.
UTM UI settings do not supply a universal QEMU command.
Read the [framebuffer workflow](https://github.com/oxtech-ember/EmberBSD/blob/main/sys/dev/fdt/docs/utm-framebuffer.md)
and [desktop Examples](https://github.com/oxtech-ember/EmberBSD-Examples/tree/main/desktop) for graphics.

Read image-specific login defaults.
The current development image permits passwordless console root and disables SSH.
Preseed applies only when integrated.
Accept console sign-in and authorized account access.
Configure requested SSH access.
Check a normal reboot.
For requested graphics, verify a visible window and input.
Record image/kernel revisions, firmware, host/backend, and results.
VM acceptance does not validate a physical board.
