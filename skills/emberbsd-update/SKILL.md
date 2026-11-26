---
name: emberbsd-update
description: "Use when updating an installed EmberBSD system, selecting signed OS sets, or choosing between OS and package updates."
---

# Update an installed EmberBSD system

Identify the installed system and the requested update.
Use the same procedure on physical machines and VMs.

1. Read `ember-update status` and `ember-update history`.
   Identify the last checked release, the running slot and any kernel hold.
2. For unattended updates, check `ember_update=YES` and the reboot policy in `/etc/rc.conf`.
   Use the installed profile to identify the available storage and boot operations.
3. Run `ember-update check` as root to refresh the signed selection.
   Run `ember-update apply` for an authorized installation.
4. On a two-slot system, check the pending generation and reboot requirement.
   After restarting, verify confirmation or rollback in the history.
   Check the running kernel, network, application and local settings.
5. On a single-root system, verify updated package registrations and application behavior.
   Follow the profile's installer for an OS upgrade.

If the command is absent, identify the installed release and follow its documented upgrade or recovery route.
For an application, use `emberbsd-manage-app`.
Use the hardware profile for boot files or recovery.
Report the release, the installed result and any outstanding boot verification.

[Native update commands](https://github.com/oxtech-ember/EmberBSD/blob/main/usr.sbin/ember-update/README.md) · [Update architecture](https://github.com/oxtech-ember/EmberBSD-Docs/blob/main/modules/updates.md)
