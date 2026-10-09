# Device diagnostics

Start with the symptom, expected behavior and selected target. Inspect the
smallest useful evidence: relevant process/service state, device enumeration,
logs, resource usage or a reproducer. Commands such as `dmesg`, `sysctl`,
`ifconfig` and `netstat` may help; verify availability and exact options locally.
Keep credentials, addresses and private content out of public reports.

Separate an application failure from its dependencies, device interface,
permissions, driver, network and firmware. Compare observations with the
current board documentation in
[EmberBSD](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards).
A related SoC or a successful VM run does not establish physical-device support.

Fix the demonstrated cause within the task's scope and retest the failed case.
Keep a focused regression when changing source. Use service restart or reboot
when the diagnosis and task call for it; coordinate shared target access when
another active task could be interrupted. Do not reboot every reachable board
because a log mentions EmberBSD.

For boot media, firmware or a whole-system update, establish the exact target,
artifact provenance and recovery path before writing. Do not mix kernels and
modules from different builds. If target access is missing, state that concrete
limitation and continue useful host-side work without presenting it as a device
check.

Close with the cause or current hypothesis, changes, verification and remaining
unknowns. A diagnostic collection alone is not a repaired user scenario.
