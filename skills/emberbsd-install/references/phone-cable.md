# USB phone/tablet installation

Use the exact model's OS-owned installer and stage documents. If the model is
unknown, use authorized read-only identity discovery first; do not advance any
installation stage. Discover available sources and host tools:

```sh
git -C "$OS_SRC" ls-files 'ember/boards/*' 'ember/*install*' 'ember/**/*install*'
command -v adb
adb version
adb devices -l
```

Select the user's device serial. For authorized read-only stock-Android inspection:

```sh
adb -s "$SERIAL" shell getprop ro.product.model
adb -s "$SERIAL" shell getprop ro.product.device
adb -s "$SERIAL" shell getprop ro.boot.flash.locked
adb -s "$SERIAL" shell getprop ro.boot.verifiedbootstate
adb -s "$SERIAL" shell id
adb -s "$SERIAL" shell su -c id
adb -s "$SERIAL" shell cat /proc/mounts
adb -s "$SERIAL" shell cat /proc/swaps
adb -s "$SERIAL" shell ls -l /dev/block
```

Set `MODEL` from verified device/user facts; search model-specific instructions
only with a nonempty identity:

```sh
test -n "$MODEL" && git -C "$OS_SRC" grep -n -i -F -e "$MODEL" -- ember README.md
```

Missing properties or `su` failure are evidence gaps, not permission to unlock.
Inspection excludes writes, reboots and transfers. Production Android commonly
needs stock `su`; do not assume `adb root`.

Current public OS sources contain a YS-M33/A133 DTS but no `ys-m33-a133-*`
installer stage documents or executable phone installer. A DTS establishes
neither protected-chain access nor EmberBSD first boot. Report the gap and stop
dependent stages; recheck current sources on later tasks.

When model-specific tooling exists, require its documented sequence:

| Stage | Required evidence before advancing |
| --- | --- |
| Inspect | Model/port match, layout, lock state, escalation, backup capability |
| Backup | Full storage and early boot areas; unmounted user partitions from recovery; serial/CID binding, verified hashes |
| Environment | Complete export; copy-first edits, valid CRC, unknown variables retained, exact restore; no active swap/zram or conflicting mount |
| Recovery hook | Self-removing, normal boot preserved, explicit USB device role; recovery-to-Android round trip |
| Unlock | Journaled unlock within exact device/loss authorization; secure-storage relock may be impossible |
| Write | Exact ranges, per-device lock, resumable session retained in recovery; stream hash and entire-area read-back |
| First boot | Documented SSH acceptance and fallback timer/boot-count behavior; fix normal boot after acceptance |

For block backups use binary-clean `adb -s "$SERIAL" exec-out su -c 'dd if=VERIFIED_BLOCK'`
redirected to a private host file, not terminal `adb shell`. Resolve the block
from the model procedure; hash both ends and compare two reads of critical
areas. Re-read environment after vendor reboots.

Userspace fastbootd and protected FEL/boot-ROM modes are not proven unlock paths.
Android unlock cannot replace signed early stages; factory signatures cannot
authenticate modified bytes, eFuse trust changes are one-way, and disabling
signature checks is unsupported. Vendor emulators do not validate protected
chains, USB roles or radios. Preserve existing action/device authorization, private-backup
and data-handling requirements from the installation skill.
