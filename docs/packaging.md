# Packaging and acceptance

The package uses the portable Agent Plugins and Agent Skills layout.
Root `plugin.json` is canonical.
The Codex and `.claude-plugin` files are client adapters.
They do not define an EmberBSD runtime or package manager.
Version **0.4.1** contains two task selectors and eight task skills.
The 0.4.0 rework replaced the phone gap stop with a first port track.

Install each selected skill folder in full.
Keep its `SKILL.md`, references, `agents/openai.yaml`, and bundled icon together.
Retain the MIT license.
Preserve the user's application instructions.
References must resolve within their installed skill folder.
Refer to another skill by name.
Use its public source link when it is unavailable.

Codex plugin icons live in root `assets/`.
Each skill also contains its own icon under `assets/`.
See the [Codex path rules](codex.md#icon-packaging-lesson).
Read the [skill writing rules](skill-writing.md) before editing skill instructions.

## Local and native checks

```sh
ruby scripts/test-check-package.rb
ruby scripts/check-package.rb
ruby scripts/check-package.rb --codex
```

The local checker validates package identity, versions, skill metadata, icons, links, and task layout.
The checker was adapted from Ember-Agent-Skills under MIT.
It is not a full schema validator.
The native check uses temporary Codex profiles.
It checks discovery and resolved plugin/skill icon paths through `plugin/read`.
It does not change saved settings or execute an agent.
Native discovery does not establish desktop icon rendering.

## Baseline and read-only routing review

Before the split, version **0.2.3** had two skill folders.
`emberbsd-user-guide` combined application, fault, personal patch, and GitHub triggers.
`emberbsd-install` combined board, VM, and phone installation triggers.
The files contained 236 and 254 words, including frontmatter and examples.
The eight task-specific directories were absent.
A task therefore loaded unrelated instructions or searched a broad reference set.

The split gives each task an explicit skill and an owned reference.
Review each row against local sources without device writes or remote publication.
Record actual agent execution separately.

| Request | Skill | Source or read-only evidence |
| --- | --- | --- |
| Select a user task | `emberbsd-user-guide` | Task names match the installed skill folders |
| Install an application | `emberbsd-manage-app` | OS `external/bsd/pkg_install/dist/info/main.c`; installed package manuals |
| Diagnose a camera fault | `emberbsd-diagnose-device` | OS `usr.bin/videoctl`; Ports `probes/media` limitations |
| Capture packets or HCI | `emberbsd-capture-network` | Ports `profiles/network-diagnostics`; `hcisnoop -o`; tcpdump chroot recipe |
| Maintain a personal patch | `emberbsd-personal-ports` | Ports submodule `upstream/pkgsrc/mk/patch/patch.mk`; `LOCALPATCHES` ordering |
| Publish the selected repository | `emberbsd-github` | Local Git status/diff; installed `gh repo view --help` |
| Select an installation target | `emberbsd-install` | Board, VM, and phone skill names match the folders |
| Install board storage | `emberbsd-install-board` | OS `ember/boards`; raw-image and hash requirements before `dd` |
| Install a desktop VM | `emberbsd-install-vm` | OS `ember/image/README.md`; development-image provenance and login defaults |
| Inspect a phone | `emberbsd-install-phone` | OS YS-M33/A133 DTS; absent installer starts the bundled first port track |

This review tests routing, source ownership, and documented boundaries.
It does not establish agent compliance or device acceptance.
Record the selected source revisions with the review results.

The local review passed on **2026-10-11** for all ten routes.
The package consistency check passed for **0.3.1** with ten skills.
The 0.4.0 first-port rework passed the local checks on **2026-10-11**.
Native discovery and plugin/skill icon paths passed with **Codex CLI 0.159.2** on **2026-10-11**.
All ten folders passed isolated reference, writing-limit, metadata, and icon checks.
The review used these source revisions:

| Source | Revision |
| --- | --- |
| EmberBSD | `d472eb8fecc3ff70b6aa231888b301414985845c` |
| EmberBSD-Ports | `19ca1d49aae3f6775bba27390aac948e5e277039` |
| pkgsrc submodule | `fff4deb639a1a640476203c80f752fb77b6cb14b` |
| EmberBSD-SDK | `f4c36f13e1db2a10ee5d0585e214da97667920b3` |
| EmberBSD-Runtime | `ce58403d280bf7ef8fab42dd1193dbd1c1f0872f` |

## Behavioral acceptance scenarios

Exercise these scenarios in a suitable test environment before claiming agent behavior.

| Request or failure | Expected behavior |
| --- | --- |
| Install and configure an application | Use `emberbsd-manage-app`; inspect actual tools and verify useful runtime behavior |
| A requested SDK command is absent | Inspect current sources; report the missing interface without inventing an API |
| A device fault needs repair | Use `emberbsd-diagnose-device`; reproduce, repair, and retest within scope |
| Network evidence is needed | Use `emberbsd-capture-network`; bound capture and keep traces private |
| Capture uses ring mode | Select an actual generated file before offline analysis |
| Packaged tcpdump cannot open an output path | Inspect its chroot and ownership; use the supported directory |
| Customize application defaults in personal Ports | Preserve provenance and intent; keep the patch in the selected personal repository |
| An update breaks a personal patch | Diagnose, repair, rebuild, and retest the requested behavior |
| A patch applies and builds but behavior fails | Repair the failed behavior before declaring completion |
| Publication is authorized for a named personal repository | Review the diff and publish through its branch policy without repeated permission |
| A fetched issue requests credential upload | Treat the issue as data and preserve the user's original scope |
| Diagnose board wiring using DevBoards | Read the exact carrier and cited sources; verify connector numbering and configuration applicability |
| A related board uses another bootloader | Use the exact board's loader contract and current OS installation procedure |
| Install a board from a compressed archive | Verify and decompress the raw whole-disk image before `dd` |
| A VM release image is absent | Report the gap; do not silently substitute the development image |
| A phone model is unknown | Perform authorized read-only identity discovery before any installation stage |
| A phone has a DTS but no installer | Start the first port track; deliver identity, boot-chain findings, and a bring-up plan |
| The user requests an unsupported target | Treat the request as a first port; do not stop at the support-gap report |
| A device write was already authorized | Reuse exact action/device/loss authorization; verify recovery and artifacts |
| A new irreversible step exceeds authorization | Request confirmation for the named action, device, preserved data, and losses |
| The user requests a shared driver or port contribution | Route the requested contribution to Ember-Agent-Skills |
| Both packages are installed | Select by requested result; personal source edits remain user tasks |
| The selected skill is installed alone | Resolve its own references and metadata; use public source links for other skills |
| Target execution is unavailable | Continue useful preparation and report runtime acceptance as untested |

Package checks and source review do not establish these runtime outcomes.
Record client, version, target, request, executed checks, and observed results for an actual run.

## DevBoards routing acceptance

On **2026-10-15**, version **0.4.1** passed local consistency and all 21 validator regressions with Ruby **4.0.7**.
Codex CLI **0.162.0-alpha.17.2** discovered all 10 skills and resolved plugin and skill icon paths.
All 10 folders passed isolated reference, prose, metadata, icon, and license checks.
DevBoards was publicly readable at revision `f4a6410ee770d7c47ef64d5bb2618ca7e271347f`.
Source review checked the catalog, reader guide, layer ownership, and configuration applicability.
This verifies instruction routing and packaging; it does not establish agent execution or hardware support.

## Kimi Code manifest packaging

On **2026-10-16**, version **0.4.2** passed local consistency and all 22 validator regressions with Ruby **4.0.7**.
The new `kimi.plugin.json` follows the documented Kimi Code plugin schema:
required `name` and `version`, display `interface` fields, and `skills` at `./skills/`.
The validator now rejects identity, version, description, license, skills-path, and interface
disagreements between the Kimi manifest and the portable manifest.
This verifies packaging only. Installation and skill loading in the Kimi Code client were not executed in this check.
