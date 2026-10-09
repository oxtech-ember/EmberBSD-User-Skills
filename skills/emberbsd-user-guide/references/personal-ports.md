# Personal Ports and upstream updates

The goal is a working personal customization that follows current upstream.
Keep the original author's source distribution, shared EmberBSD portability
adaptations and the user's requested behavior changes identifiable.
A personal Ports repository stores recipes/patches and their intent; it need
not become a fork containing the complete upstream source history.

## Make the first customization

1. Identify the user's requested behavior and a small acceptance scenario.
   Inspect the selected program, current release and existing personal changes.
2. Inspect the current shared Ports recipe and its build instructions. Preserve
   upstream licenses, source URLs and integrity checks. Prefer cross-compilation
   where the recipe supports it, with execution on the target.
3. Reuse or create the user's selected personal repository as authorized. Read
   [GitHub](github.md) before publication. Keep credentials and local paths out
   of versioned files.
4. Change the program and create a focused patch with a short explanation of
   its purpose. Record the upstream base and any shared Ports base actually used.
   Keep the user's independent changes intact.
5. Build and exercise the requested behavior. Address failures before calling
   the result ready. Publish the checked patch to the authorized personal repo,
   using its established branch policy and normal Git operations.

## Follow an upstream update

Fetch the new supported upstream version and inspect relevant changes. Apply
the shared adaptations and personal patch using the owning recipe's documented
mechanism. A rejected hunk is a repair task: compare old and new behavior,
update the patch, rebuild and rerun the affected acceptance cases.

A patch applying cleanly is not proof that its behavior survived. Test the
customization and affected ordinary behavior, including a relevant failure case.
If upstream implements the desired feature, confirm equivalence before retiring
the patch. Do not remove the user's customization merely to make a build pass.
Retain the last usable version and user data while validating its replacement.

The loop is: update, diagnose, repair, verify and save the new working state.
Record revisions and checks during that loop; do not require a separate lockfile,
artifact service or reproducibility platform before attempting a small change.
Unexpected source checksum changes require investigation, not blind acceptance.

## Use actual Ports mechanisms

Read the current [EmberBSD-Ports documentation](https://github.com/oxtech-ember/EmberBSD-Ports).
Do not assume that a multi-repository overlay resolver or personal-Ports CLI
already exists. With pkgsrc, `LOCALPATCHES` applies source patches after the
normal recipe patches; it does not modify the recipe Makefile itself. External
patch integrity must be recorded separately. Confirm these semantics in the
selected pkgsrc version before using them; avoid unexplained patch stacking.
If a recipe change is needed, version it in the personal repository with its
base and application instructions using currently available tools.

A useful general fix may be offered to shared Ports or upstream when authorized.
That is a separate contribution workflow through Ember-Agent-Skills. A personal
repository does not require a PR to either destination.
