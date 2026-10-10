# Install on a desktop computer: virtual machine

EmberBSD currently builds and boots as an aarch64 system. On a desktop
computer the supported path is a virtual machine with a ready-made image, not
bare-metal installation: there is no x86-64 port, and an x86 host runs the
aarch64 guest under QEMU emulation with its performance and device limits.
State that boundary instead of promising a native desktop installation.

## Import the image

1. Obtain the published aarch64 VM image (qcow2) and its SHA256 from the
   EmberBSD repository's releases or README instructions; verify before use.
   If no public VM image is published yet, report that rather than building
   an unofficial one silently.
2. On Apple Silicon, import into UTM: an ARM64 QEMU `virt` machine with UEFI
   firmware, VirtIO disk and network, several CPUs and gigabytes of RAM, and
   a serial console attached. Attach the qcow2 as its disk.
3. On other hosts, use plain QEMU with the same machine type, firmware and
   VirtIO devices. Reproducible examples of EmberBSD VM scenarios live in
   [EmberBSD-Examples](https://github.com/oxtech-ember/EmberBSD-Examples).

## First boot

The serial console is the primary interface before network configuration.
Sign in on the console, set the root password or create a user, and enable
sshd deliberately; VM images ship no default password. The same preseed
rules as boards apply when the image supports them.

Virtual machines are also the project's acceptance environment for package
installation and graphics scenarios; running software inside the VM after
setup belongs to `emberbsd-user-guide`.
