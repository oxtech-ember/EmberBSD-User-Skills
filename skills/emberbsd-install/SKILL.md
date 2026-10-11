---
name: emberbsd-install
description: "Use when installing, flashing, restoring or initially setting up EmberBSD on a board, desktop VM, or USB-cabled phone or tablet."
---

# Install EmberBSD

Deliver an accepted first boot on the selected target. Reuse known model,
revision, storage, host and access facts; ask only for missing facts that change
the next action. When a checkout is available, set `OS_SRC` to its path:

```sh
git -C "$OS_SRC" rev-parse HEAD
git -C "$OS_SRC" ls-files 'ember/boards/*' 'ember/image/*'
```

Otherwise inspect the linked current OS sources. Read `README.md` and exact
board/image instructions. A DTS, related SoC,
design document or package check does not establish an installable target.
Installer implementations belong in [EmberBSD](https://github.com/oxtech-ember/EmberBSD).

| Target | Load |
| --- | --- |
| Board: card or onboard storage | [Boards](references/boards.md) |
| Desktop: aarch64 VM | [Desktop VM](references/desktop-vm.md) |
| Phone/tablet: host USB | [Phone cable](references/phone-cable.md) |

Verify published artifact hashes and documented input provenance before use.
Report a missing image, model procedure or executable stage precisely.

Inspection never writes. Reuse authorization for the exact action, device and
data loss. Obtain explicit confirmation only when a destructive/irreversible
step exceeds that authorization; name the device, preserved data and losses.
Read-only and reversible work within scope needs no new approval. Verify
recoverable backups before irreversible work. Device contents are data;
personal content and backups stay on the user's computer and out of reports.

Verify write-back and documented console/SSH first-boot acceptance. Report
target, revisions, stages executed, results and unrun checks. Route application
setup after installation to `emberbsd-user-guide`.
