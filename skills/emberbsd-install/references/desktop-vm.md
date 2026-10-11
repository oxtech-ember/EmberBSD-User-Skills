# Desktop VM installation

Use an aarch64 guest, not an assumed x86-64 or bare-metal desktop port. Apple
Silicon may use UTM/QEMU with HVF; other hosts require documented QEMU emulation
and its limits. Discover the actual artifact's requirements:

```sh
git -C "$OS_SRC" ls-files 'ember/image/*' 'ember/boot/*utm*'
command -v qemu-img qemu-system-aarch64
qemu-system-aarch64 --version
qemu-system-aarch64 -machine help
```

Use published qcow2/checksum when available. The OS-owned
[development image](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/image)
declares verified NetBSD 11 base sets plus accepted EmberBSD components; it is
separate from a complete general release. Use its builder only for a requested
development image, never silently as a substitute for a missing release.

Verify the hash, then inspect the image offline:

```sh
qemu-img info --output=json "$IMAGE"
qemu-img check "$IMAGE"
```

Use the owning launch recipe: aarch64 `virt`, matching UEFI, VirtIO disk/network,
serial console, documented CPU/RAM/backend. UTM UI configuration does not supply
a universal QEMU command. Graphics details live in
[the OS framebuffer workflow](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/boot/utm-framebuffer.md)
and [Examples](https://github.com/oxtech-ember/EmberBSD-Examples/tree/main/desktop).

Accept console sign-in, configure authorized account/SSH access and test a normal
reboot. Read image-specific login defaults: the documented development image
permits passwordless console root and disables SSH. Preseed applies only if
integrated. Record image/kernel revisions, firmware, host/backend and results;
VM success does not validate a physical board.
