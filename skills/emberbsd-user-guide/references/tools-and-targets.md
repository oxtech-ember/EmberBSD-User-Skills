# Discover tools and targets

Run discovery in the selected device shell. For existing authorized SSH access,
use a noninteractive connection with a 10s connection timeout; set `TARGET`
from that selected connection:

```sh
ssh -o BatchMode=yes -o ConnectTimeout=10 "$TARGET" \
  'uname -srm && id && df -h'
```

The connection timeout does not bound remote command execution; use the available
runner's overall timeout when needed. Then inspect installed tools in its shell
or through the existing connector:

```sh
uname -a
id
command -v pkg_info pkg_add pkgin ps df dmesg sysctl
pkg_info -a
ps -ax -o pid,comm
df -h
```

Keep host/device paths distinct. Inspect installed commands' manuals/options and
actual release provenance. NetBSD ABI names alone do not identify current EmberBSD.
Use narrow output; keep tokens, addresses, personal files and process
environments out of public reports. Prefer documented structured output and
retain each exit status before dependent actions. `git grep`/`rg` status 1 means
no match; errors need diagnosis. Missing access blocks target checks, not host work.

For source tasks, set `OS_SRC`, `PORTS_SRC` and `EXAMPLES_SRC` to available selected
checkouts; otherwise inspect their linked public sources. Discover owners:

```sh
git -C "$OS_SRC" rev-parse HEAD
git -C "$PORTS_SRC" status --short --branch
git -C "$PORTS_SRC" ls-files 'profiles/*/README.md' 'probes/*/README.md'
git -C "$EXAMPLES_SRC" ls-files '*README.md' '*.sh'
```

Read the applicable README, recipe, configuration and help before execution.
Use `git grep` or `rg` for focused source lookup. Do not assume Linux
`systemctl` or `/proc` on EmberBSD; discover its actual rc/service mechanism.

[SDK](https://github.com/oxtech-ember/EmberBSD-SDK) and
[Runtime](https://github.com/oxtech-ember/EmberBSD-Runtime) currently describe
design boundaries, with no released CLI/API. Recheck current sources before
using future interfaces. Existing operations belong to OS, Ports and Examples;
skills route to those tools instead of implementing wrappers. Cross builds
use the owning recipe and provenanced EmberBSD sysroot; declared development
images may have explicit NetBSD inputs. Never silently substitute base parts.
