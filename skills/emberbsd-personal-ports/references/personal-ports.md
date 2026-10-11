# Personal patch operations

Set `PORTS_SRC`, `RECIPE`, and `PERSONAL_PATCHES` from the selected checkouts and private patch directory.
Keep host and target paths separate.
Read the owning [Ports](https://github.com/oxtech-ember/EmberBSD-Ports) recipe and build instructions.
Preserve the upstream distribution and shared EmberBSD adaptations.
Store personal patches and their intent in the selected repository.
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
Use the recipe's supported cross-build path and EmberBSD sysroot with verified origin.
Declared development images can have explicit NetBSD inputs.
Do not silently substitute base components.
Recipe changes require a versioned diff, base revision, and application command.
No personal-Ports CLI or overlay resolver is assumed.

## Maintain the result

Compare upstream changes before applying an update.
Apply shared adaptations before personal adaptations through the owning mechanism.
Investigate unexpected checksum changes.
Repair rejected hunks and failed behavior checks.
Keep the customization while rebuilding and retesting.
A clean patch or build does not establish accepted behavior.

Test the customization, ordinary behavior, and a relevant failure case on the selected VM or device.
Record revisions, patch hashes, checks, and unrun target tests.
Preserve the last usable software and data while testing its replacement.
Publish checked files only to the authorized personal destination.
If `emberbsd-github` is available, use it.
A personal patch does not require an upstream PR or separate artifact platform.
