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

Read `man pkg_add`, `man pkg_delete`, or installed `pkgin help`.
Preview a selected archive with `pkg_add -n "$ARCHIVE"`.
Inspect the proposed dependencies.
Use the actual tool's authorized install, update, or removal command.
Preserve the requested data retention during removal.
Do not invent an EmberBSD package wrapper or whole-system upgrade.

If a current release is absent, inspect the owning
[Ports recipe](https://github.com/oxtech-ember/EmberBSD-Ports).
Follow that recipe's build instructions.
Do not select obsolete software only because a snapshot contains it.

Discover service ownership from package file lists and actual rc files.
If the selected script implements `status`, `start`, or `restart`, use the authorized action.
Do not assume Linux `systemctl` or `/proc` on EmberBSD.

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
Do not use OS as an umbrella for other projects' documentation.
For personal patches, read the Ports recipe's patch mechanism.
If `emberbsd-personal-ports` is available, use it.
