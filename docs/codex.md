# Codex adapter

Use a Codex CLI whose local help provides these plugin commands:

```sh
codex plugin marketplace add oxtech-ember/EmberBSD-User-Skills --ref main
codex plugin list --marketplace emberbsd-user-skills --available --json
codex plugin add emberbsd-user@emberbsd-user-skills
```

The catalog is `emberbsd-user-skills`; the package is `emberbsd-user`, version
`0.2.0`. Start a new conversation and select `$emberbsd-user-guide` for device
operations or `$emberbsd-install` to install EmberBSD on a board, a desktop VM
or an A133 phone. The separate
`emberbsd-development@ember-agent-skills` package can remain installed.

Refresh the catalog with `codex plugin marketplace upgrade emberbsd-user-skills`.
Check the installed version separately; refresh/reinstall through the client's
supported workflow if it still uses an old snapshot. Inspect `codex --version`
and `codex plugin --help` if any command is unavailable.

The root manifest's `extensions.com.openai` and the skill's `agents/openai.yaml`
supply presentation metadata. The catalog points to the root with `./`.
This skills-only package has no account connection or MCP configuration.

## Verified boundary

Local consistency and native discovery passed on **2026-10-09** with
**Codex CLI 0.162.0-alpha.17.2** for package **0.1.0**:

```sh
ruby scripts/check-package.rb --codex
```

The check uses a temporary profile and a command-line local catalog override.
It verifies the plugin identifier and version without installing into the user's
saved profile. This is not an on-device execution test or a behavioral acceptance
result. The package has not been submitted to OpenAI's public directory.
