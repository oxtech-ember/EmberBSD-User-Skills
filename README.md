# EmberBSD User Skills

Instructions for AI agents that assist [EmberBSD](https://github.com/oxtech-ember/EmberBSD) users.
Use real CLI/API tools to complete the requested task.
Keep personal software changes in the user's selected Ports repository.

Version **0.4.10** provides ten small skills.
Each task skill has a narrow trigger, short instructions, and its own required references.
The two legacy entry points now select a task skill.
The package uses [Agent Plugins](https://agent-plugins.org/) and [Agent Skills](https://agentskills.io/home).

## Select a task skill

| Skill | Use it when |
| --- | --- |
| [`emberbsd-user-guide`](skills/emberbsd-user-guide/SKILL.md) | An EmberBSD user task needs skill selection |
| [`emberbsd-manage-app`](skills/emberbsd-manage-app/SKILL.md) | You need to install, configure, update, or remove an application |
| [`emberbsd-diagnose-device`](skills/emberbsd-diagnose-device/SKILL.md) | A device or application has a fault |
| [`emberbsd-capture-network`](skills/emberbsd-capture-network/SKILL.md) | You need packet/HCI evidence or network measurements |
| [`emberbsd-personal-ports`](skills/emberbsd-personal-ports/SKILL.md) | You need a personal application patch across upstream updates |
| [`emberbsd-github`](skills/emberbsd-github/SKILL.md) | You need to create, synchronize, or publish the selected repository |
| [`emberbsd-install`](skills/emberbsd-install/SKILL.md) | An installation task needs target selection |
| [`emberbsd-install-board`](skills/emberbsd-install-board/SKILL.md) | You need EmberBSD on a board's card or onboard storage |
| [`emberbsd-install-vm`](skills/emberbsd-install-vm/SKILL.md) | You need an aarch64 guest on a desktop VM host |
| [`emberbsd-install-phone`](skills/emberbsd-install-phone/SKILL.md) | You need installation inspection or a first port track for a USB-connected phone or tablet |

Load only the skills needed for the requested result.
Each folder works alone with its bundled references, Codex metadata, and icon.
Skills refer to other skills by name.
Public source links provide instructions when another skill is unavailable.
Legacy reference paths remain as short links to their new owners.

## Keep the requested scope

| Package | Intended tasks |
| --- | --- |
| **EmberBSD-User-Skills** (`emberbsd-user`) | Device operation, application configuration, personal patches, personal Ports publication, and supported installation |
| [**Ember-Agent-Skills**](https://github.com/oxtech-ember/Ember-Agent-Skills) (`emberbsd-development`) | Application development, OS changes, board development, shared ports, and requested contributions |

Personal third-party patches and their builds remain user tasks.
A personal patch does not require an upstream PR.
Select the package by the requested result when both packages are installed.
Reuse authorization for the exact action, target, and data loss.
Keep credentials, private traces, and backups out of public reports.

For example, ask your assistant:

> Use emberbsd-personal-ports to change this application's default behavior in my personal Ports repository.
> Test the change with the current upstream release.
> Use emberbsd-github to publish it to the repository I selected.

A completed build does not establish the requested behavior.
The assistant must investigate failures and rerun the affected checks.
Target execution remains untested when the selected device is unavailable.

## Install the package or a skill

Use your client's documented installation mechanism.

1. For Agent Plugins, load the repository root and select `emberbsd-user`.
2. For Agent Skills, load each selected `skills/<name>/` folder in full.
3. For manual use, read the selected `SKILL.md` and its required references.

Retain the repository's [MIT license](LICENSE).
Manual reading does not register automatic discovery.
Keep your project's existing instructions.

See the [Codex adapter](docs/codex.md) for that client.
ZCode and Claude Code use `.claude-plugin/marketplace.json`.
In ZCode, add `oxtech-ember/EmberBSD-User-Skills` through **Settings → Plugin Management → Discover → `+`**.
Install `emberbsd-user` from that catalog.
In Claude Code, use these commands:

```text
/plugin marketplace add oxtech-ember/EmberBSD-User-Skills
/plugin install emberbsd-user@emberbsd-user-skills
```

Kimi Code reads `kimi.plugin.json` at the repository root.
Install from the Plugins screen or run:

```text
/plugins install oxtech-ember/EmberBSD-User-Skills
```

Reinstall the plugin after a release; Kimi Code does not update it automatically.

Grok Build reads `.grok-plugin/marketplace.json`.
Add the marketplace and install the plugin:

```sh
grok plugin marketplace add oxtech-ember/EmberBSD-User-Skills
grok plugin install emberbsd-user --trust
```

The catalog entry clones this repository from GitHub.
Grok rejects a repository-root path such as `./` in a catalog entry.
To update, run `grok plugin marketplace update` and `grok plugin update emberbsd-user`.

The portable format does not prescribe a universal installation command.

## Tools and current limits

Skills contain instructions and packaging checks.
They do not supply a package manager, device agent, GitHub client, credentials, or MCP server.
[SDK](https://github.com/oxtech-ember/EmberBSD-SDK) provides development-host
build orchestration, workspace and sysroot tools, and release kits. Stable application contracts and
[Runtime](https://github.com/oxtech-ember/EmberBSD-Runtime) remain separate work.
The assistant must recheck current sources before using future interfaces.
[Ports](https://github.com/oxtech-ember/EmberBSD-Ports) owns shared recipes and compatibility patches.
Your personal Ports owns your chosen behavior changes.
Standalone UI applications belong in Examples or their own repository.
OS documentation belongs beside its subsystem; it is not an umbrella for every project.
Skills provide concise routes to owner documentation without copying implementation contracts.

A phone model without an OS installer is a first port, not a refusal.
The phone skill runs read-only identity inspection and its first port track.
The track collects identity, boot chain, and prior art, then proposes the bring-up plan.
The OS development VM image declares its own input provenance.
It remains separate from a general installation release.
[EmberBSD-DevBoards](https://github.com/oxtech-ember/EmberBSD-DevBoards) owns hardware descriptions and current support guidance with explicit limits.
Its [reader guide](https://github.com/oxtech-ember/EmberBSD-DevBoards/blob/main/docs/reader-guide.md)
and [catalog](https://github.com/oxtech-ember/EmberBSD-DevBoards/blob/main/catalog.json)
lead to board, carrier, SoC, interface, bootloader, and storage-layout records.
Check the exact profile before installation or diagnosis.
OS software mechanisms, API contracts, image builders, and executable checks stay beside their implementation.
OS image guides explain builder mechanics; DevBoards defines hardware applicability and boot layouts.
Keep one canonical support description without test chronology or duplicate catalogs.

## Validate the package

Run the local consistency check:

```sh
ruby scripts/test-check-package.rb
ruby scripts/check-package.rb
```

Add `--codex` for isolated native discovery and icon path checks.
Add `--grok` for an isolated Grok Build install of the committed `HEAD`.
Version **0.3.1** passed those native checks with Codex CLI **0.159.2** on **2026-10-11**.
Version **0.4.0** passed the local consistency checks on **2026-10-11**.
See [packaging and acceptance](docs/packaging.md) for version-specific evidence and task scenarios.
Version **0.4.1** passed package checks, 21 validator regressions, isolated skill checks, and native Codex discovery on **2026-10-15**.
See the [DevBoards routing checks](docs/packaging.md#devboards-routing-acceptance) for evidence and limits.
Version **0.4.2** added the Kimi Code manifest and passed package checks with 22 validator regressions on **2026-10-16**.
See [Kimi Code manifest packaging](docs/packaging.md#kimi-code-manifest-packaging) for evidence and limits.
Version **0.4.3** added the Grok Build catalog.
See [Grok Build marketplace packaging](docs/packaging.md#grok-build-marketplace-packaging) for evidence and limits.
Personal Ports guidance reuses the current stack for each target ABI.
Personal changes retain their own checks and provenance.
Build guidance follows the [SDK tool selection procedure](https://github.com/oxtech-ember/EmberBSD-SDK/blob/main/docs/tool-selection.md).
Select native and target Clang/LLVM separately. Use GCC only for an explicit platform requirement.

Package checks do not execute device workflows or establish agent behavior.
Desktop icon rendering and on-device acceptance require separate checks.
See [skill writing rules](docs/skill-writing.md) for the controlled English style.

## License

[MIT](LICENSE).
