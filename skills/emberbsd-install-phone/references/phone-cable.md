# Phone cable stages

Use the exact model's OS-owned installer and stage documents.
Set `OS_SRC` to the selected checkout when available.
Otherwise read the current [OS sources](https://github.com/oxtech-ember/EmberBSD).

```sh
git -C "$OS_SRC" ls-files 'ember/boards/*' 'ember/*install*' 'ember/**/*install*'
command -v adb
adb version
adb devices -l
```

Select the user's device serial.
Use the following commands only for authorized read-only stock-Android inspection.

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

Set `MODEL` from verified device or user facts.
Search model instructions only with a nonempty identity.

```sh
test -n "$MODEL" && git -C "$OS_SRC" grep -n -i -F -e "$MODEL" -- ember README.md
```

Inspection excludes writes, reboots, and transfers.
Missing properties or failed `su` are evidence gaps.
Do not assume `adb root` on production Android.
Current sources contain a YS-M33/A133 DTS without executable phone tooling or `ys-m33-a133-*` stage documents.
Stop dependent stages until the model's procedure exists.

When model-specific tooling exists, require this evidence before advancing.

| Stage | Required evidence |
| --- | --- |
| Inspect | Model/port match; layout; lock state; escalation; backup capability |
| Backup | Full storage and early boot areas; unmounted user partitions in recovery; serial/CID binding; verified hashes |
| Environment | Complete export; copy-first edits; valid CRC; retained unknown variables; exact restore; no active swap/zram or conflicting mount |
| Recovery hook | Self-removal; preserved normal boot; explicit USB device role; recovery-to-Android round trip |
| Unlock | Journaled action; exact device/loss authorization; documented secure-storage relock limits |
| Write | Exact ranges; per-device lock; recovery session retained for resume; stream hash; entire-area read-back |
| First boot | Documented SSH acceptance; fallback timer/boot-count behavior; normal boot repaired after acceptance |

Resolve backup blocks from the exact model procedure.
Use binary-clean `adb -s "$SERIAL" exec-out su -c 'dd if=VERIFIED_BLOCK'` redirected to a private host file.
Do not use terminal `adb shell` for block backups.
Hash both ends.
Compare two reads of critical areas.
Re-read the environment after vendor reboots.

Userspace fastbootd and protected FEL/boot-ROM modes are not proven unlock paths.
Android unlock cannot replace signed early stages.
Factory signatures cannot authenticate modified bytes.
eFuse trust changes are irreversible.
Disabling signature checks is unsupported.
Vendor emulators do not validate protected chains, USB roles, or radios.
