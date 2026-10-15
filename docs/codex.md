# Codex adapter

Use a Codex CLI whose help provides these commands:

```sh
codex plugin marketplace add oxtech-ember/EmberBSD-User-Skills --ref main
codex plugin list --marketplace emberbsd-user-skills --available --json
codex plugin add emberbsd-user@emberbsd-user-skills
```

The catalog is `emberbsd-user-skills`.
The package is `emberbsd-user`, version `0.4.1`.
Start a new conversation after installation.
Select the task skill directly when you know the task.

| Task | Codex skill |
| --- | --- |
| Select a user task | `$emberbsd-user-guide` |
| Manage an application | `$emberbsd-manage-app` |
| Diagnose a fault | `$emberbsd-diagnose-device` |
| Capture network evidence | `$emberbsd-capture-network` |
| Maintain a personal patch | `$emberbsd-personal-ports` |
| Manage the selected GitHub repository | `$emberbsd-github` |
| Select an installation target | `$emberbsd-install` |
| Install board storage | `$emberbsd-install-board` |
| Install an aarch64 desktop VM | `$emberbsd-install-vm` |
| Inspect or install a USB-connected phone | `$emberbsd-install-phone` |

The separate `emberbsd-development@ember-agent-skills` package can remain installed.
Refresh the catalog through the supported command.

```sh
codex plugin marketplace upgrade emberbsd-user-skills
```

Check the installed version separately.
Use the client's supported refresh or reinstall workflow for an old snapshot.
Inspect `codex --version` and `codex plugin --help` when a command is unavailable.

Root `extensions.com.openai` and each skill's `agents/openai.yaml` provide presentation metadata.
The catalog points to the plugin root with `./`.
This package has no account connection or MCP configuration.

## Icon packaging lesson

ZCode and Claude Code use the catalog's public `icon` URL.
Codex uses `extensions.com.openai.interface.composerIcon` and `logo` in root `plugin.json`.
Their `./assets/emberbsd-logo.png` paths start at the plugin root.
The other clients' icon URL does not supply Codex metadata.

Each skill has `interface.icon_small` and `icon_large` in its `agents/openai.yaml`.
Those paths start at the skill directory, not `agents/`.
All ten skills contain `assets/emberbsd-logo.png` for standalone installation.
The checker compares each copy with the root logo.
Use the PNG directly.
The root SVG wraps an external PNG.

Field names and path bases follow Codex's
[plugin parser](https://github.com/openai/codex/blob/8c0f7011674145da7e10627769fb221c74fbf7a0/codex-rs/core-plugins/src/manifest.rs)
and [skill metadata reference](https://github.com/openai/codex/blob/8c0f7011674145da7e10627769fb221c74fbf7a0/codex-rs/skills/src/assets/samples/skill-creator/references/openai_yaml.md).
The native check exercises the installed CLI's app-server `plugin/read` method.
`codex plugin list` checks discovery and release metadata.
Its JSON does not expose icon fields.

## Verified boundary

Run the version-specific checks before making a release claim:

```sh
ruby scripts/check-package.rb --codex
```

The check uses a temporary profile and a local catalog override.
It verifies the plugin identifier and version.
A separate temporary app-server profile checks resolved `composerIcon`, `logo`, `iconSmall`, and `iconLarge` paths.
Package **0.3.1** passed with **Codex CLI 0.159.2** on **2026-10-11**.
All ten skills passed native discovery and icon path resolution.
The check does not install into a saved user profile.
Desktop rendering, on-device execution, and agent behavior require separate evidence.
The package has not been submitted to OpenAI's public directory.
