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
Select published artifacts for the installed profile.
For an S3 release, fetch the required artifacts with the installed SDK client and verify their identities together.
For a supported installation medium, verify the full image and its matching sets.
If a required component is unavailable, report its identity before changing the running system.
Use the installation profile to select its supported upgrade procedure.
For machine-specific boot files or recovery, consult the matching loader or hardware profile.
Preserve the package inventory, local configuration and user data.
After reboot, verify the kernel revision, installed base, modules, network, application settings and service behavior.
Report download, installation and boot verification separately.

Read the [update architecture](https://github.com/oxtech-ember/EmberBSD-Docs/blob/main/modules/updates.md) for services, settings and the package update cycle.
