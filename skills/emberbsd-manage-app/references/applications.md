# Application operations

Run discovery in the selected target shell.
Use the existing authorized connection.
Keep host and target paths separate.
For SSH, use noninteractive access with `BatchMode=yes` and `ConnectTimeout=10`.
Use the available runner's overall timeout for remote execution.
Check release provenance.
A NetBSD ABI name alone does not identify current EmberBSD.

```sh
uname -srm
id
command -v pkg_info pkg_add pkg_delete pkgin
```

Inspect the selected installed package.

```sh
pkg_info -e "$PACKAGE"
pkg_info -B "$PACKAGE"
pkg_info -L "$PACKAGE"
pkg_info -N "$PACKAGE"
pkg_info -R "$PACKAGE"
```

## Update installed packages

Read `ember-update status` and `ember-update history` as an ordinary user.
Run `ember-update check` as root to refresh the signed package selection.
Use `ember-update apply` for an authorized update.
Check the resulting package versions, saved settings and a useful application action.

For unattended updates, check `ember_update=YES` and `ember_update_packages=YES` in `/etc/rc.conf`.
The service checks at boot and periodically.
On two-slot systems, inspect the pending transaction and the configured reboot window.
After restarting, check confirmation in the update history.
On single-root systems, check the installed versions after the update completes.

If verification fails, inspect the reported error, system time, network and release trust anchor.
If the base client is missing, consult the installed image's release procedure.
[Native client and service](https://github.com/oxtech-ember/EmberBSD/blob/main/usr.sbin/ember-update/README.md) · [Device update guide](https://github.com/oxtech-ember/EmberBSD-Docs/blob/main/modules/updates.md)

## Other package operations

Use `ember-update catalog` to find an application in the signed catalog.
As root, run `ember-update install "$PKGPATH" --pkgname "$PKGNAME"` with the selected catalog values.
Verify registration immediately on a single root or after trial confirmation on two slots.
For an explicitly selected local archive or a removal, read `man pkg_add` or `man pkg_delete`.
Preview a selected archive with `pkg_add -n "$ARCHIVE"`.
Inspect the proposed dependencies.
Use the actual tool's authorized install, update, or removal command.
Preserve the requested data retention during removal.
Use package operations verified in the installed tools.

For a requested source build, inspect the owning
[Ports recipe](https://github.com/oxtech-ember/EmberBSD-Ports).
Follow that recipe's build instructions.
Select the current supported recipe and adapt dependencies when a snapshot is stale.

Discover service ownership from package file lists and actual rc files.
If the selected script implements `status`, `start`, or `restart`, use the authorized action.
Use EmberBSD's verified rc scripts and installed diagnostic interfaces.

Verify a meaningful request and a relevant failure case.
Graphical applications require a visible window and input check.
Camera applications require capture from the selected camera.
A version string or build does not establish those results.

Read the current [SDK](https://github.com/oxtech-ember/EmberBSD-SDK) and
[Runtime](https://github.com/oxtech-ember/EmberBSD-Runtime) sources before using their interfaces.
SDK owns host build orchestration, sysroots, and release kits.
Runtime and stable application contracts remain separate work.
Use OS subsystem documentation for OS mechanisms.
Use Ports for dependency recipes and upstream patches.
Use Examples or the application's repository for standalone UI applications.
For module boundaries and configuration choices, read
[EmberBSD-Docs](https://github.com/oxtech-ember/EmberBSD-Docs).
Source code is also documentation; keep exact behavior in owner sources, schemas, tests, and help.
When documenting changes, follow the guide's
[ownership rules](https://github.com/oxtech-ember/EmberBSD-Docs/blob/main/CONTRIBUTING.md#separate-concepts-from-implementation).
For personal patches, read the Ports recipe's patch mechanism.
If `emberbsd-personal-ports` is available, use it.
