# Applications

Establish the requested behavior, current package/version, target architecture
and package source. Inspect the installed package manager's help and repository
configuration. Use existing package tools such as pkg_tools or pkgin only when
available; do not assume their presence or invent an EmberBSD wrapper.

Inspect the proposed transaction and affected dependencies. Prefer a current
supported release. When a needed modern version is unavailable, inspect
[EmberBSD-Ports](https://github.com/oxtech-ember/EmberBSD-Ports) and the actual
recipe before choosing a build path. Age in a pkgsrc snapshot is not a reason
to select an obsolete application. Keep one coherent dependency set; repair
consumers instead of adding a permanent old library for each application.

Apply the requested installation or configuration with the existing tools.
Preserve user data and unrelated settings. An application request does not
implicitly request a whole-system upgrade, reboot or firmware replacement.
For removal, distinguish package removal from deletion of user documents and
configuration. Follow the user's intended retention rather than erasing them
as an incidental cleanup step.

Verify startup, required functionality and persistence where relevant. For a
service, check its actual lifecycle mechanism, a meaningful request and failure
behavior. For a graphical app, a command-line version string alone does not
prove a working window. For a camera app, compilation alone does not prove
capture from the selected camera.

If the desired behavior requires source edits, use [personal Ports](personal-ports.md).
A common portability fix may be prepared separately through the developer
skills when contributing that fix is part of the task.
