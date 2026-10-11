# Device and application diagnostics

Start with [target discovery](tools-and-targets.md), the symptom and expected
behavior. Capture the smallest relevant read-only evidence:

| Layer | Installed command candidates |
| --- | --- |
| Kernel/device | `dmesg`, `drvctl -l`; `drvctl -l "$PARENT"` for the selected subtree |
| Process/package | `ps -ax -o pid,comm`, `pkg_info -B "$PACKAGE"`, `pkg_info -L "$PACKAGE"` |
| Network | `ifconfig "$IFACE"`, `netstat -rn` |
| Camera | `ls -l /dev/video*`, then `videoctl -d "$VIDEO_DEVICE" -a` |
| Bluetooth | `btconfig -l` |

Check local manuals and derive names from enumeration. Query commands do not
prove capture, throughput or pairing. Reproduce with the app's real CLI/API;
inspect its config, backend and dependencies. Source ownership is OS
`usr.bin/videoctl`/driver/board pages, Ports recipe/profile, or the app. For media,
read [Ports' media probe](https://github.com/oxtech-ember/EmberBSD-Ports/tree/main/probes/media):
its documented OpenCV backend choices and VM checks do not establish physical
camera support. SDK/Runtime names do not supply diagnostic commands.

Repair the demonstrated cause within scope, preserve personal patches, and
retest the failed behavior plus affected regressions. Read the
[exact board page](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards);
a similar SoC or VM result does not establish hardware support. Coordinate
shared access before disruptive restart/reboot. Firmware/media/system writes
need exact artifact provenance, matching kernel/modules and a recovery path;
route installation to `emberbsd-install`.

## Packet and HCI evidence

The [Ports network profile](https://github.com/oxtech-ember/EmberBSD-Ports/tree/main/profiles/network-diagnostics)
owns capture/analysis packages and `hcisnoop`. Check `command -v` and
`pkg_info`; install missing supported tools via [applications](applications.md).
Select interface, peer, direction, duration and a private output location.
Capture only task-relevant traffic; traces may contain credentials/personal data.
Ring mode suffixes the `-w` base: select an actual generated file as `TRACE`
before offline analysis.

```sh
iperf3 -c "$PEER" -t 10 -J
iperf3 -c "$PEER" -t 10 -R -J
dumpcap -i "$IFACE" -b filesize:1024 -b files:4 -a duration:30 -w "$CAPTURE"
capinfos "$TRACE"
tshark -r "$TRACE"
btconfig -l
hcisnoop -o "$BTSNOOP"
```

Check help before use and stop HCI capture after the selected event. For packaged
tcpdump, `cd /var/tcpdump`, verify directory ownership `_tcpdump`, then run
`tcpdump -i "$IFACE" -s 0 -w capture.pcap` with required capture privileges.
Its privilege-drop/chroot makes outside absolute output paths fail.

Record protocol, peer/direction, duration, loss/jitter and capture drop counters;
Wi-Fi and wired results differ. Ring buffering bounds storage. Bluetooth may
require the OS's model-specific module/`btattach` setup; distinguish scans from
pairing/ACL/SCO traffic. Use `editcap`/`mergecap` per help for private trace
processing. Return cause/hypothesis, repair, verification and unknowns; diagnostic
collection alone is not a repaired scenario.
