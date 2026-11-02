---
name: emberbsd-personal-ports
description: "Use when making or maintaining a personal EmberBSD application patch across upstream updates."
---

# Maintain a personal EmberBSD patch

Identify the behavior, application, repository, and acceptance case.
Read [personal patch operations](references/personal-ports.md).
Inspect the current release and owning recipe.
Keep upstream sources, shared adaptations, and personal changes identifiable.

Preserve source URLs, licenses, and integrity checks.
Record upstream and shared base revisions.
Keep unrelated user edits and the last usable version.
Make a focused personal patch through the owning recipe's mechanism.
Use the supported cross-build path and matching EmberBSD target sysroot.
Follow the [SDK tool selection procedure](https://github.com/oxtech-ember/EmberBSD-SDK/blob/main/docs/tool-selection.md).
Use Clang/LLVM by default. Select GCC only for a documented platform limit, such as missing LLVM support.
Select host and target families independently; never switch after failure.
Use current shared dependency versions.
Never install older compilers or libraries to satisfy dependency builds.

Test ordinary behavior and a relevant failure case on the selected target.
If an update breaks the patch, diagnose and repair the changed source within scope; rebuild and rerun acceptance.
Add causal tests for logic or behavior fixes; trivial order, typo, or path fixes need none.
Retire a patch only when upstream meets the requested behavior.

Save patch hashes, intent, revisions, and test results in the selected personal repository.
Publish only to an authorized destination.
If `emberbsd-github` is available, use it.
Otherwise follow the repository's documented publication workflow.
Keep credentials and private data out of saved records.

A personal patch does not require a shared PR.
Use Ember-Agent-Skills for a shared contribution only when requested.
