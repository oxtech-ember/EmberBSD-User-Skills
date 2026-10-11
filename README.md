# EmberBSD User Skills

Agent skills for people using [EmberBSD](https://github.com/oxtech-ember/EmberBSD):
install and configure applications, diagnose devices, and maintain personal
software changes through their own Ports repository and GitHub.

Version **0.2.3** provides two skills:
[`emberbsd-install`](skills/emberbsd-install/SKILL.md) for installing
EmberBSD onto boards, desktop virtual machines, and USB-cabled phones, and
[`emberbsd-user-guide`](skills/emberbsd-user-guide/SKILL.md) with
focused references for applications, diagnostics, personal Ports, and GitHub.
Install methods stay device-general; board-specific procedures live in the
[OS repository](https://github.com/oxtech-ember/EmberBSD/tree/main/ember/boards).
It uses the portable [Agent Plugins](https://agent-plugins.org/) and
[Agent Skills](https://agentskills.io/home) formats.

## Two packages, two purposes

| Package | Use it for |
| --- | --- |
| **EmberBSD-User-Skills** (`emberbsd-user`) | Operate your device, configure applications, change an existing program for your needs, maintain and publish patches in your personal Ports |
| [**Ember-Agent-Skills**](https://github.com/oxtech-ember/Ember-Agent-Skills) (`emberbsd-development`) | Develop applications, change EmberBSD itself, bring up boards, maintain shared ports, and contribute tested fixes |

Editing source and compiling a personal modification remain a user workflow.
They do not require a contribution to EmberBSD or the original upstream.
A reusable fix can enter the developer workflow when you request that contribution.
Both packages can coexist; select by the requested outcome.

These skills can guide an assistant running on the device or working remotely.
They discover the available tools and follow their documented interfaces.
This release contains instructions and packaging checks. It does not supply
an on-device agent, package manager, GitHub client, credentials, MCP server,
or implemented SDK/Runtime interfaces.

## Start with a user task

After loading the skill, ask your assistant, for example:

> Use emberbsd-user-guide to change this application's default behavior,
> keep the patch in my personal Ports repository, and verify that it still
> works with the current upstream release. Publish to the repository I selected.

The workflow keeps upstream sources, shared EmberBSD portability fixes and
personal changes distinct. When an update breaks a patch or a test, the agent
investigates and repairs it within the requested scope, then tests again.
Success means the requested behavior works on the target. A completed build
alone is not enough.

Other tasks include installing an application, configuring a service, and
collecting evidence for a device fault. Installation of the OS itself is a
separate skill with its own references:

- [Boards: cards and onboard storage](skills/emberbsd-install/references/boards.md)
- [Desktop VM](skills/emberbsd-install/references/desktop-vm.md)
- [Cable installation of phones](skills/emberbsd-install/references/phone-cable.md)

Instructions are loaded as needed:

- [Tools and targets](skills/emberbsd-user-guide/references/tools-and-targets.md)
- [Applications](skills/emberbsd-user-guide/references/applications.md)
- [Device diagnostics](skills/emberbsd-user-guide/references/device-diagnostics.md)
- [Personal Ports](skills/emberbsd-user-guide/references/personal-ports.md)
- [GitHub workflows](skills/emberbsd-user-guide/references/github.md)

## Load the package

Use your client's documented installation mechanism:

1. For Agent Plugins with skills support, load the repository root and select
   `emberbsd-user`.
2. For Agent Skills support, load the complete `skills/emberbsd-user-guide/`
   and `skills/emberbsd-install/` directories, including their references and
   the repository's MIT license.
3. For manual use, ask the assistant to read `SKILL.md` and the relevant linked
   references. This does not register automatic discovery.

See the [Codex adapter](docs/codex.md) for one concrete client. ZCode and
Claude Code discover the bundled `.claude-plugin/marketplace.json` catalog:
in ZCode add the GitHub repository `oxtech-ember/EmberBSD-User-Skills` through
**Settings → Plugin Management → Discover → `+`** and install `emberbsd-user`;
in Claude Code use `/plugin marketplace add oxtech-ember/EmberBSD-User-Skills`
and `/plugin install emberbsd-user@emberbsd-user-skills`. The portable
format does not prescribe a universal installation command or require Codex.
Keep your project's instructions. Root `AGENTS.md` governs contributions to
this repository; it is not a replacement for device or application policies.

## Ownership and validation

[EmberBSD-Ports](https://github.com/oxtech-ember/EmberBSD-Ports) owns shared
third-party recipes and compatibility patches. Your personal Ports owns your
chosen behavior changes. [SDK](https://github.com/oxtech-ember/EmberBSD-SDK)
and [Runtime](https://github.com/oxtech-ember/EmberBSD-Runtime) own their
application contracts and device operations when implemented. Skills explain
how to use real tools; they do not create substitute APIs.

Package consistency passes for **0.2.3**; the `.claude-plugin` catalog and
plugin manifest were verified against the marketplace and plugin manifest
locations and name rules that the ZCode and Claude Code loaders probe.
Native Codex discovery and plugin/skill icon path resolution passed for **0.2.3**
with **Codex CLI 0.159.2** on **2026-10-11**. These checks neither install
into saved user settings nor execute the workflows. On-device operation,
agent behavior and end-to-end personal Ports maintenance have not been
validated by these checks. Desktop icon rendering and other clients remain
untested for this release.

Run `ruby scripts/check-package.rb` for consistency, or add `--codex` for
isolated native discovery and icon path checks. See [packaging and acceptance](docs/packaging.md)
for the check boundaries and behavioral scenarios.

## License

[MIT](LICENSE).
