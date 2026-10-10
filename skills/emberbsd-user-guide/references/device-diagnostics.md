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

## Network diagnostics on the device

For connectivity and throughput problems, capture evidence instead of arguing
from symptoms. The [network diagnostics kit](https://github.com/oxtech-ember/EmberBSD-Ports/tree/main/profiles/network-diagnostics)
ships libpcap, tcpdump, iperf3 and the Wireshark CLI tools (dumpcap, tshark,
capinfos, editcap, mergecap) as installable packages, plus `hcisnoop` for
Bluetooth HCI recording. Check `pkg_info` first; a missing tool is a package
to install, not a missing capability.

- The packaged tcpdump drops privileges and chroots to `/var/tcpdump`, so run
  it from that directory and write captures with a relative `-w` name; the
  directory must belong to the `_tcpdump` account. Absolute paths outside the
  chroot fail with a confusing "No such file or directory".
- Measure throughput with an explicit peer and direction (`iperf3 -c`, `-R`
  for reverse), record protocol, duration and the reported loss and jitter
  instead of quoting one bitrate. Wi-Fi and wired results are not
  interchangeable.
- `dumpcap -b filesize:KB -a files:N` records a ring buffer of pcapng files;
  under heavy traffic read the interface drop counters it reports rather than
  trusting the captured packet count.
- On the device, `tshark -r`, `capinfos`, `editcap` and `mergecap` read,
  inspect and transform captured files; copy pcaps, pcapng and BTSnoop traces
  to the analysis machine for interactive inspection.
- `hcisnoop -o FILE` records the native Bluetooth HCI tap to BTSnoop that
  Wireshark opens as "Bluetooth HCI H4". On minimal images the controller may
  need manual bring-up (loading its module and `btattach`) before any HCI
  traffic exists; confirm the unit with `btconfig -l` and record pairing or
  ACL/SCO traffic separately from a scan.

Close with the cause or current hypothesis, changes, verification and remaining
unknowns. A diagnostic collection alone is not a repaired user scenario.
