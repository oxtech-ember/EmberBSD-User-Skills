# Capture and measurement

The [Ports network profile](https://github.com/oxtech-ember/EmberBSD-Ports/tree/main/profiles/network-diagnostics)
owns capture packages and `hcisnoop`.
Discover tools in the selected target shell.
Keep host and target paths separate.
For SSH, use existing authorized access with `BatchMode=yes` and `ConnectTimeout=10`.
Use the available runner's overall timeout for remote execution.

```sh
command -v iperf3 dumpcap capinfos tshark tcpdump btconfig hcisnoop editcap mergecap
pkg_info -a
```

Read the installed help and manuals.
Install missing supported tools through their package instructions.
If `emberbsd-manage-app` is available, use it.
Do not invent SDK or Runtime commands.

Select the interface, peer, direction, duration, and private output path.
Set `LOCAL_ADDR` to the selected interface's local address.
Run only the measurements authorized for that peer.

```sh
iperf3 -c "$PEER" --bind "$LOCAL_ADDR" -t 10 -J
iperf3 -c "$PEER" --bind "$LOCAL_ADDR" -t 10 -R -J
dumpcap -i "$IFACE" -b filesize:1024 -b files:4 -a duration:30 -w "$CAPTURE"
```

Ring mode adds suffixes to the `-w` base.
Set `TRACE` to an actual generated file.

```sh
capinfos "$TRACE"
tshark -r "$TRACE"
btconfig -l
hcisnoop -o "$BTSNOOP"
```

Stop HCI capture after the selected event.
Bluetooth can require the OS model's module and `btattach` setup.
Distinguish scans from pairing, ACL, and SCO traffic.

For packaged tcpdump, inspect the selected recipe's `VARBASE` and chroot directory.
The default directory is `/var/tcpdump`.
Verify directory ownership by `_tcpdump`.
Change to that directory before capture.

```sh
tcpdump -i "$IFACE" -s 0 -w capture.pcap
```

Use the required capture privileges.
The package's privilege drop and chroot can prevent absolute output paths outside that directory.
Keep the capture private after processing.

Record the protocol, peer, direction, duration, loss, jitter, and capture drop counters.
Ring buffering bounds storage.
Wired results do not establish Wi-Fi performance.
Use `editcap` or `mergecap` according to installed help for private trace processing.
Report missing counters and untested paths explicitly.
