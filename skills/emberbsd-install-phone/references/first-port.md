# First port track

Run this track when the OS sources provide no installer for the selected phone.
Deliver a bring-up plan with evidence; a gap report alone does not solve the task.

## Fix the identity

Record the vendor, model, board, revision, and storage type.
Record the SoC, RAM size, radio, and display controller.
Record the boot ROM or bootloader version and its entry mode.
Record the USB vendor and product IDs in that mode.
For Apple DFU, read the mode, CPID, CID, BDID, ECID, and nonce with `irecovery -q`.

## What to search

Search upstream NetBSD for the SoC family, machine types, and IP blocks.
Search the current kernel configuration and `sys/arch` for similar supported boards.
Search mainline Linux and postmarketOS device trees for memory maps, clocks, and pinmux.
Search vendor and community kernels for drivers of the same SoC.
Treat GPL code as documentation; do not copy it into BSD-licensed sources.
Search the platform boot chain: boot ROM, signed stages, and the kernel entry contract.
Search loaders that already boot alternative systems on the device.
Record each loader, its image format, console path, and license.
Record the community status of storage, display, USB, and radio.

## What to check before code

- SoC memory map and console path: UART pins, USB console, or framebuffer.
- Interrupt controller, timers, and clocks needed by a running kernel.
- The image contract of the selected boot path: entry address, format, and arguments.
- Persistent storage access and its command protocol.
- Power, reset, and thermal behavior during development.
- The recovery path back to the vendor OS.

## Bring-up order

Start from the smallest image the selected boot path accepts.
Bring up console, then memory, timers, and interrupts, then storage.
Then bring up USB or network, then userspace, then the documented SSH first boot.
Keep each step reproducible from a clean commit.

## Safety

Keep RAM-only experiments inside the granted boot-path authorization.
Name exact ranges before any write to boot areas or storage.
A first boot in RAM is a bring-up step, not an installation.
Follow the phone cable stage table for later installation stages.
