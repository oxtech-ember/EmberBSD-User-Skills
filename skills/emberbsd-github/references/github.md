# Repository publication

Set `PERSONAL` to the selected checkout.
Use available connected tools, Git, or GitHub CLI.
Inspect their documented interfaces.

```sh
git -C "$PERSONAL" remote
git -C "$PERSONAL" status --short --branch
git -C "$PERSONAL" diff
git -C "$PERSONAL" diff --cached
```

Remote URLs can contain credentials.
Resolve and sanitize URLs programmatically before tool output.
Do not print credential values or borrow another repository's credentials.

With GitHub CLI, inspect the selected checkout metadata.

```sh
(cd "$PERSONAL" && gh repo view --json nameWithOwner,isPrivate,defaultBranchRef)
gh api user --jq .login
```

Use existing authentication.
Missing access is a specific blocker.
Use documented endpoints and the authentication for the selected account.

For requested creation, read `gh repo create --help` or the connected tool schema.
Use the selected owner and visibility.
Synchronize through the established repository workflow.
Preserve unrelated edits.

Review publication files before staging.
For documentation changes, read the
[concept and implementation rules](https://github.com/oxtech-ember/EmberBSD-Docs/blob/main/CONTRIBUTING.md#separate-concepts-from-implementation).
Keep architecture, module relationships, design reasons, and configuration choices in EmberBSD-Docs.
Source code is also documentation; keep exact behavior in owner sources, schemas, tests, manuals, and help.
Update conceptual explanations when the requested change affects them.
For precise implementation changes alone, update owner documentation and check guide links.
Keep personal patch explanations in the selected personal repository.
Exclude secrets, personal data, private paths, unredistributable downloads, and build outputs.
Select the files explicitly.

```sh
git -C "$PERSONAL" add -- "$PATCH_FILE" "$RECORD_FILE"
git -C "$PERSONAL" diff --cached --check
git -C "$PERSONAL" diff --cached
git -C "$PERSONAL" commit -m "$MESSAGE"
git -C "$PERSONAL" push "$REMOTE" "$BRANCH"
git -C "$PERSONAL" rev-parse HEAD
git -C "$PERSONAL" ls-remote --heads "$REMOTE" "$BRANCH"
```

Check each exit status before the next dependent action.
Respect branch protection.
If branch policy or the user requires a PR, use one.
Compare the published commit with the local intended commit.
Return the destination link.
Keep PR creation, publication, and merge outcomes separate.
Personal publication does not authorize a shared contribution.
