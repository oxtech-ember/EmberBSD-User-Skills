---
name: emberbsd-personal-ports
description: "Use when making or maintaining a personal EmberBSD application patch across upstream updates."
---

# Maintain a personal EmberBSD patch

Identify the requested behavior, selected application, and personal repository.
Define a small acceptance case.
Read [personal patch operations](references/personal-ports.md).
Inspect the current release and owning Ports recipe.
Keep upstream sources, shared adaptations, and personal changes identifiable.

Preserve source URLs, licenses, and integrity checks.
Record upstream and shared base revisions.
Keep unrelated user edits and the last usable version.
Make a focused personal patch through the owning recipe's mechanism.
Use the supported cross-build path and matching EmberBSD target sysroot.
Follow the [SDK tool selection procedure](https://github.com/oxtech-ember/EmberBSD-SDK/blob/main/docs/tool-selection.md).
Use GCC16 and current shared dependency versions.
Never install older compilers or libraries to satisfy dependency builds.

Test the customization on the selected target.
Check ordinary behavior and a relevant failure case.
If an update breaks the patch, diagnose the changed source.
Repair the patch within the requested scope.
Rebuild the affected software.
Rerun the acceptance checks.
Retire a patch only when upstream behavior satisfies the requested result.

Save patch hashes, intent, revisions, and test results in the selected personal repository.
Publish only to an authorized destination.
If `emberbsd-github` is available, use it.
Otherwise follow the repository's documented publication workflow.
Keep credentials and private data out of saved records.

A personal patch does not require a shared PR.
Use Ember-Agent-Skills for a shared contribution only when requested.
