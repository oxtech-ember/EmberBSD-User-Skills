---
name: emberbsd-update
description: "Use when updating an installed EmberBSD system, selecting signed OS sets, or choosing between OS and package updates."
---

# Update an installed EmberBSD system

Use the same entry for a VM or physical machine.
Identify the requested update and the installed system.

For an application or automatic package updates, use `emberbsd-manage-app`.
If it is unavailable, follow the [package client and service routes](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/tools/docs/installed-system-update.md).
Check the installed package version, application behavior and saved settings.

For the OS, follow the [installed system update procedure](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/tools/docs/installed-system-update.md).
Record the running revision, installed sets, architecture, boot path and recovery method.
Check whether the image has two provisioned slots and the `ember_os_update` service.
For that profile, follow the [automatic OS update procedure](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/tools/docs/automatic-system-update.md).
Check the service log for the selected generation, trial boot and confirmation or rollback.
For a manual installation profile, collect the verified sets for its supported installer.
Report any missing component before changing the running system.
For machine-specific boot files or recovery, consult the matching loader or hardware profile.
Preserve the package inventory, local configuration and user data.
After reboot, verify the kernel revision, installed base, modules, network, application settings and service behavior.
Report download, installation and boot verification separately.

Read the [update architecture](https://github.com/oxtech-ember/EmberBSD-Docs/blob/main/modules/updates.md) for services, settings and the package update cycle.
