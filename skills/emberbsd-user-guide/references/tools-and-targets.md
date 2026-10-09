# Discover tools and targets

Identify which commands run on the assistant's host and which run on the
EmberBSD device. Reuse the user-selected connection; do not choose a different
board just because it responds. Inspect the reported OS, architecture and
installed release information. Retained NetBSD ABI names do not prove that
an image contains current EmberBSD components.

Use narrow, read-only discovery. Depending on what is installed, `uname`,
`command -v`, `pkg_info`, `ps`, `df` and a tool's local manual/help can establish
the environment. Do not assume Linux-specific service commands or `/proc`.
Check the target's actual service/configuration mechanism before editing it.

For an application task, establish the package manager, repositories, package
version, configuration location, running process and required device access.
For a source task, inspect Git remotes, branch, local changes and the recipe's
documented build commands. Keep host paths and target paths distinct.

Prefer a tool's structured output when documented, preserve its exit status,
and collect only the diagnostics needed for the task. Do not dump tokens,
process environments or unrelated private files into reports.

Use installed connectors, command-line tools or SSH according to their actual
capabilities and permissions. A missing tool is a specific dependency to resolve,
not evidence that an imagined SDK command exists. Check the current contents of
[SDK](https://github.com/oxtech-ember/EmberBSD-SDK) and
[Runtime](https://github.com/oxtech-ember/EmberBSD-Runtime) before using their
interfaces. Repository ownership does not establish an implemented service.

For cross builds, use the owning recipe and an EmberBSD sysroot with known source
revisions. Do not silently replace base libraries, headers or the kernel with
upstream NetBSD components. Run acceptance on the intended VM or device.
