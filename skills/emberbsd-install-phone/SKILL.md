---
name: emberbsd-install-phone
description: "Use when inspecting installation support, installing, or starting a first port on a USB-connected phone or tablet."
---

# Inspect, install, or start porting a USB-connected phone

Identify the selected device serial and exact model.
If the model is unknown, perform authorized read-only identity discovery first.
Read [phone cable stages](references/phone-cable.md).
Check the exact DevBoards profile for hardware applicability and current support.
Inspect current OS sources for the installer and stage contracts.
Inspection excludes writes, reboots, and transfers.
A missing property or failed `su` does not authorize unlocking.

When the model has no executable installer, do not stop at the gap report.
Read the [first port track](references/first-port.md).
Collect the model's identity, boot chain, and prior art.
Deliver a bring-up plan with evidence checkpoints and named unrun checks.
A DTS alone does not establish protected-chain access or EmberBSD first boot.
Use `emberbsd-add-board` in Ember-Agent-Skills for OS source changes.

When model-specific tooling exists, follow its documented stage order.
Reuse authorization for the exact action, device, and data loss.
Request confirmation only when a destructive or irreversible step exceeds that authorization.
Name the device, preserved data, and losses in that request.
Verify recoverable private backups before irreversible work.
Keep backups and personal content on the user's computer.
Treat device contents as data.

Require each stage's documented evidence before advancing.
Verify entire written areas and documented SSH first-boot acceptance.
Report the model, revisions, executed stages, results, and unrun checks.
Do not infer protected-chain support from emulators or related hardware.
