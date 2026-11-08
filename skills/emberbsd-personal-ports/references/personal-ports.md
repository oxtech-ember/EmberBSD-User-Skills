# Personal patch operations

Set `PORTS_SRC`, `RECIPE`, and `PERSONAL_PATCHES` to the selected local paths.
Keep host and target paths separate.
Read the owning [Ports](https://github.com/oxtech-ember/EmberBSD-Ports) recipe and build instructions.
Preserve the upstream distribution and shared EmberBSD adaptations.
Store personal patches and intent in the selected repository.
A full upstream fork is not required.

## Discover the patch mechanism

Use the selected recipe's configured `bmake`.

```sh
bmake -C "$RECIPE" show-var VARNAME=PKGPATH
bmake -C "$RECIPE" show-var VARNAME=WRKSRC
git -C "$PORTS_SRC/upstream/pkgsrc" grep -n LOCALPATCHES -- mk/patch/patch.mk
```

Query `LOCALPATCHES` inside the `upstream/pkgsrc` submodule.
The parent Ports repository does not track the submodule's internal files.
Confirm the mechanism in the selected version.
Current `LOCALPATCHES` appends `$LOCALPATCHES/$PKGPATH/*` after normal source patches.
It does not edit the recipe Makefile.
Keep external patch hashes in the personal repository.

If the recipe supports the patch stage, run it.

```sh
bmake -C "$RECIPE" LOCALPATCHES="$PERSONAL_PATCHES" patch
```

Run the documented build and package checks.
Use the recipe's cross-build path and matching EmberBSD sysroot.
Select host and target compiler families independently from their SDK prefixes.
Use Clang/LLVM by default; select GCC only for documented platform limits.
Repair compilation failures while retaining the selected compiler families.
Keep the runtime consistent with the target ABI.
Resolve tools inside the selected prefix. Check host CPU compatibility. Reject external fallbacks.
Allow host system ABI headers and libraries only for native tools.
Acquisition and workspace inspection do not require a completed SDK.
Declared development images can have explicit NetBSD inputs.
Preserve the declared provenance of base components.
Recipe changes require a versioned diff, base revision, and application command.
No personal-Ports CLI or overlay resolver is assumed.

## Maintain the result

Compare upstream changes before updating. Apply shared, then personal adaptations through the owner.
Investigate checksum changes. Repair rejected hunks and failed behavior.
Rebuild and retest the customization. A clean patch or build does not establish accepted behavior.

Test the customization, ordinary behavior, and a relevant failure case on the selected VM or device.
Record revisions, patch hashes, checks, and unrun target tests.
Preserve the last usable software and data while testing its replacement.
Publish checked files only to the authorized personal destination.
If `emberbsd-github` is available, use it.
A personal patch does not require an upstream PR or separate artifact platform.

## Design rules

Design the simplest change before coding.
Repair the owning implementation and verify the affected contract.
Move existing common logic into a shared layer before extending it.
Make the customization switchable through configuration.
Pass device differences through generic properties and operation tables.
Build on the development host with the current shared package stack for the target ABI.
Reuse its shared objects, packages, and sysroot by their [input key](https://github.com/oxtech-ember/EmberBSD-SDK/blob/main/docs/input-keys.md).
Keep incompatible ABIs separate.
Make builds work on case-insensitive file systems.
Use common Mesa and Plasma recipes for every board of each target ABI.
Keep personal changes explicit and separate from shared package acceptance.
Reuse shared acceptance and recorded input identity when the input key matches.
Retest the customization and affected behavior.
Install only runtime files on the device; keep development tools on the host.
If the fix helps all users, propose it as a shared change.
