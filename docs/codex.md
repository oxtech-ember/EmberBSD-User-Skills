# Codex adapter

Use a Codex CLI whose local help provides these plugin commands:

```sh
codex plugin marketplace add oxtech-ember/EmberBSD-User-Skills --ref main
codex plugin list --marketplace emberbsd-user-skills --available --json
codex plugin add emberbsd-user@emberbsd-user-skills
```

The catalog is `emberbsd-user-skills`; the package is `emberbsd-user`, version
`0.2.3`. Start a new conversation and select `$emberbsd-user-guide` for device
operations or `$emberbsd-install` to install EmberBSD on a board, a desktop VM
or a USB-cabled phone. The separate
`emberbsd-development@ember-agent-skills` package can remain installed.

Refresh the catalog with `codex plugin marketplace upgrade emberbsd-user-skills`.
Check the installed version separately; refresh/reinstall through the client's
supported workflow if it still uses an old snapshot. Inspect `codex --version`
and `codex plugin --help` if any command is unavailable.

The root manifest's `extensions.com.openai` and the skill's `agents/openai.yaml`
supply presentation metadata. The catalog points to the root with `./`.
This skills-only package has no account connection or MCP configuration.

## Icon packaging lesson

ZCode and Claude Code use the `icon` URL in `.claude-plugin/marketplace.json`.
Codex uses `extensions.com.openai.interface.composerIcon` and `logo` in root
`plugin.json`; their `./assets/emberbsd-logo.png` paths start at the **plugin
root**. The other clients' icon URL does not supply Codex's icon metadata.

Each skill's `agents/openai.yaml` uses `interface.icon_small` and `icon_large`,
with paths relative to the **skill directory**, not `agents/`. Both skills
bundle `assets/emberbsd-logo.png` so standalone installs retain their icons.
The checker compares these copies with the root logo. Use the PNG directly;
the root SVG wraps an external PNG.

Field names and path bases were checked against Codex's
[plugin parser](https://github.com/openai/codex/blob/8c0f7011674145da7e10627769fb221c74fbf7a0/codex-rs/core-plugins/src/manifest.rs)
and [skill metadata reference](https://github.com/openai/codex/blob/8c0f7011674145da7e10627769fb221c74fbf7a0/codex-rs/skills/src/assets/samples/skill-creator/references/openai_yaml.md),
then exercised through the installed CLI's app-server `plugin/read` method.
`codex plugin list` checks discovery and release metadata; its JSON does not
expose the icon fields.

## Verified boundary

Local consistency, native discovery and native plugin/skill icon path resolution
passed on **2026-10-11** with **Codex CLI 0.159.2** for package **0.2.3**:

```sh
ruby scripts/check-package.rb --codex
```

The check uses a temporary profile and a command-line local catalog override.
It verifies the plugin identifier and version, then uses a separate temporary
app-server profile for `plugin/read` to check resolved `composerIcon`, `logo`,
`iconSmall` and `iconLarge` paths. It does not install into the user's saved
profile. Desktop rendering, on-device execution and agent behavior remain
unverified. The package has not been submitted to OpenAI's public directory.
