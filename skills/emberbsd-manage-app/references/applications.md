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

Use the image's native client to get compatible binaries from the signed S3 channel.
Use a root shell for these commands with the image's configured state and cache.
Define this shell function:

```sh
client() {
    /usr/pkg/bin/python3.15 -I /usr/local/libexec/ember-sdk.pyz \
        --config /usr/local/etc/ember-sdk.json "$@"
}
client installed
client plan --installed
```

For one application, preview with `client plan --installed --package "$ROOT"`.
Set `ROOT` to its installed Ports path, such as `archivers/zstd`.
Run `client update --package "$ROOT"` for that application or `client update` for all installed packages.
Check the resulting versions, application settings and a useful application action.
If verification fails, check network access, time and the configured trust root before retrying.

For automatic updates, inspect the [image service](https://github.com/oxtech-ember/EmberBSD/blob/main/ember/image/README.md#package-updates-on-a-running-system).
On an image with this service, set `ember_pkg_update=YES` in `/etc/rc.conf.d/ember_pkg_update`.
Start `/etc/rc.d/ember_pkg_update` with its `start` action when needed.

```sh
/etc/rc.d/ember_pkg_update status
grep ember_pkg_update /var/log/messages | tail
```

After a requested reboot, check the log for a successful pass and test the application with its saved settings.
If the client or service is missing, identify the component and consult the installed system's provisioning procedure.
The image builder installs the package layer only when creating a fresh image.
Read the [SDK update contract](https://github.com/oxtech-ember/EmberBSD-SDK/blob/main/docs/automatic-updates.md) for retry behavior and package selection.

## Other package operations

Read `man pkg_add`, `man pkg_delete`, or installed `pkgin help`.
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
