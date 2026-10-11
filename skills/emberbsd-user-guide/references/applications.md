# Application operations

Identify requested behavior, architecture, package/version, repository and
configuration. With installed pkg_tools, inspect before changing anything:

```sh
pkg_info -e "$PACKAGE"
pkg_info -B "$PACKAGE"
pkg_info -L "$PACKAGE"
pkg_info -N "$PACKAGE"
pkg_info -R "$PACKAGE"
```

Read `man pkg_add`, `man pkg_delete`, or installed `pkgin help`. For a selected
archive, `pkg_add -n "$ARCHIVE"` previews its transaction; inspect dependencies,
then use the actual tool's authorized install/update/remove command. Do not
invent an EmberBSD package wrapper or whole-system upgrade. Preserve user data,
unrelated settings and intended retention on removal.

If a needed current release is absent, inspect
[Ports](https://github.com/oxtech-ember/EmberBSD-Ports) and its owning recipe/build
instructions. Do not choose obsolete software merely because a snapshot
contains it. Keep one coherent dependency set and repair its consumers.

Discover service ownership from package file lists and actual rc files. Use
the selected rc script's documented `status`/`start`/`restart` only when it
implements those actions. Validate a meaningful request and relevant failure
case, plus persistence when requested. Graphical apps need visible window/input;
camera apps need capture from the selected camera. Version strings and builds
do not establish either.

Source customization uses [personal Ports](personal-ports.md); shared
contributions use developer skills only when requested.
