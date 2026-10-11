# Device and application evidence

Run read-only discovery in the selected target shell.
Keep host and target paths separate.
For SSH, use existing authorized access with `BatchMode=yes` and `ConnectTimeout=10`.
The connection timeout does not bound remote command execution.
Use the available runner's overall timeout for remote execution.
Check release provenance.
A NetBSD ABI name alone does not identify current EmberBSD.

```sh
uname -srm
id
command -v dmesg drvctl ps pkg_info ifconfig netstat videoctl btconfig
```

Read the installed manuals before using each command.
Derive device names from enumeration.

| Layer | Read-only command candidates |
| --- | --- |
| Kernel/device | `dmesg`, `drvctl -l`, `drvctl -l "$PARENT"` |
| Process/package | `ps -ax -o pid,comm`, `pkg_info -B "$PACKAGE"`, `pkg_info -L "$PACKAGE"` |
| Network | `ifconfig "$IFACE"`, `netstat -rn` |
| Camera | `ls -l /dev/video*`, `videoctl -d "$VIDEO_DEVICE" -a` |
| Bluetooth | `btconfig -l` |

Query output does not prove capture, throughput, or pairing.
Reproduce the fault through the application's implemented interface.
Inspect its configuration, backend, and dependencies.
Keep process environments, addresses, and personal files out of public reports.
Record command exit status before a dependent action.

Check the [exact board page](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards).
A related SoC or VM result does not establish physical support.
Device tools belong to the OS `usr.bin/videoctl`, `sbin/drvctl`, or `usr.sbin/btconfig` sources.
Application dependencies belong to the owning Ports recipe or application.

Read the [media probe](https://github.com/oxtech-ember/EmberBSD-Ports/tree/main/probes/media) for its backend limitations.
Its OpenCV file-processing checks do not establish physical camera support.
The current SDK and Runtime do not provide released diagnostic commands.
Recheck their sources before using future interfaces.

Repair the demonstrated cause within scope.
Retest the failed behavior and affected regressions.
Require matching kernel/modules, exact artifact provenance, and recovery before system writes.
Use `emberbsd-install` for an installation task.
For packet or HCI evidence, read the
[network profile](https://github.com/oxtech-ember/EmberBSD-Ports/tree/main/profiles/network-diagnostics).
If `emberbsd-capture-network` is available, use it.
