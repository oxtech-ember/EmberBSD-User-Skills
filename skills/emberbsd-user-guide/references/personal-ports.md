# Personal Ports

Keep upstream distributions, shared EmberBSD adaptations and requested personal
behavior changes identifiable. Store recipes/patches and intent in the selected
personal repository; a full upstream fork or contribution PR is unnecessary.

1. Define a small acceptance case; inspect current release, personal changes
   and the owning [Ports](https://github.com/oxtech-ember/EmberBSD-Ports) recipe.
2. Preserve licenses, source URLs and integrity checks. Record upstream/shared
   base revisions; unexpected checksum changes require investigation.
3. Make a focused patch. Keep independent user edits and the last usable
   version/data while testing its replacement.
4. Use the recipe's build commands and supported cross-build path; run acceptance
   on the selected VM/device, including the customization, ordinary behavior
   and a relevant failure case.
5. Save checked patches and results; publish only to the authorized personal
   destination following [GitHub](github.md).

## Discover the actual patch mechanism

For a selected pkgsrc recipe with its configured `bmake`:

```sh
bmake -C "$RECIPE" show-var VARNAME=PKGPATH
bmake -C "$RECIPE" show-var VARNAME=WRKSRC
git -C "$PORTS_SRC/upstream/pkgsrc" grep -n LOCALPATCHES -- mk/patch/patch.mk
```

Current `LOCALPATCHES` appends `$LOCALPATCHES/$PKGPATH/*` after normal source
patches. Confirm in the selected version; it does not edit the recipe Makefile.
Keep external-patch hashes separately. Where applicable, exercise the recipe's
patch stage with `bmake -C "$RECIPE" LOCALPATCHES="$PERSONAL_PATCHES" patch`,
then its documented build/package checks. Recipe changes need a versioned diff,
base and application command in the personal repository. No multi-repository
overlay resolver or personal-Ports CLI is assumed.

## Upstream updates

Fetch the supported update, compare changed behavior, apply shared then personal
adaptations using the owning mechanism. Rejected hunks and failed tests require
repair, rebuild and retest. Clean application/build is insufficient. Retire a
patch only after upstream behavior matches the requested customization; never
drop it to make a build pass.

Record new revisions, patch hashes and checks during the loop. A separate
artifact platform/lockfile is not a prerequisite. Useful shared fixes enter the
developer contribution workflow only when authorized.
