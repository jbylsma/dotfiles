# Moving a host from Stow to chezmoi

The dotfiles used to be deployed with GNU Stow, from a checkout at
`~/usr/src/dotfiles`. `main` now holds the chezmoi layout, and the old layout
is frozen on the `stow` branch. These are the steps for a host that's still on
Stow.

## Before you start

A Stow host still tracking `main` breaks if its old `terminal-update` runs.
The pull deletes `stow/`, which breaks every stowed link, and then the update
fails calling `restow-common`. Don't run `terminal-update` on a host until it's
migrated, or switched to `stow`.

To switch a host to `stow`:

```sh
git -C ~/usr/src/dotfiles fetch origin
git -C ~/usr/src/dotfiles checkout -b stow --track origin/stow
```

A plain `git checkout stow` fails, because the repo also has a `stow/`
directory. The explicit form works on git 1.8 too. From then on,
`terminal-update` pulls `stow`.

RHEL 7 hosts stop here. They stay on `stow` until they're retired, because
chezmoi's floor is RHEL 8.

## Each host (RHEL 8+, Debian)

1. **Save the host-local files:** copy `~/.bashrc.local`,
   `~/.bash_profile.local`, and `~/.gitconfig.local` to
   `~/.local/state/dotfiles-migration/`, if they exist.
2. **Unstow.** From `~/usr/src/dotfiles/stow`, run `stow -D` for each package,
   with the same `-t` used to stow it:
   - `-t ~`: `bash`, `git`, `misc`, `tmux`, and `vim`
   - `-t ~/usr/bin`: `bin`
   - workstations, `-t ~`: `regolith3`, `alacritty`, `gimp`, and `claude`
   - workstations: `applications`, with its usual `-t`
   - workstations: delete the absolute links that `restow-regolith3` created
     (the `_system_links` targets) by hand
3. **Check nothing is left:** `find ~ -xdev -lname '*dotfiles/stow/*'`
   prints nothing. This also matches relative links, such as `~/usr/bin`'s.
4. **Move the host-local files:**
   - `~/.gitconfig.local` to `~/.config/git/config.local`
   - `~/.bash_profile.local` to `~/.profile.local`, rewritten as POSIX sh.
     Check it with `dash -n`.
   - `~/.bashrc.local` stays.
5. **Set up:**
   ```sh
   git clone https://github.com/jbylsma/dotfiles.git ~/.local/share/chezmoi
   ~/.local/share/chezmoi/misc/bootstrap
   ```
6. **Workstations:** log out and back in, because the X session reads
   `~/.profile` only at login. Restart any running Claude Code sessions too,
   because they keep the hook paths they loaded at startup. Keep a TTY login
   (Ctrl+Alt+F3) open until the new login works, as a fallback for fixing
   `~/.profile`.
7. **Check:** `chezmoi status` prints nothing, and a new login shell has
   `~/.local/bin` first in `PATH`.

## Roll back

Before the clean-up below:

1. Remove what chezmoi deployed:
   `chezmoi managed --include files,symlinks --path-style absolute`, then
   delete those paths.
2. Run `chezmoi purge`, which removes chezmoi's config, state, and source
   directory.
3. Put the host-local files back from `~/.local/state/dotfiles-migration/`.
4. Restow with `stow/bin/restow-common` (and `restow-regolith3` on
   workstations) from the `stow` checkout.

## Clean up, once the host works

1. Delete `~/usr/src/dotfiles`.
2. If present, delete what the old bootstrap scripts built:
   - the Stow build under `~/usr` (`bin/stow`, `bin/chkstow`, its Perl
     modules, and its man and info pages), and `~/usr/src/stow-*`
   - the RHEL 9 Perl bootstrap's output (`~/usr/perl-rpm`, `~/usr/perl5`,
     `~/usr/share/perl5`, and `~/usr/src/perl-rpms`)
3. Remove empty directories under `~/usr`, bottom up, with
   `find ~/usr -depth -type d -empty -delete`. Move any tool that's left, such
   as a hand-installed `composer`, to `~/.local/bin`. Then remove `~/usr`.
4. Delete `~/.local/state/dotfiles-migration/`.

Once the last RHEL 7 host is retired, delete the `stow` branch.
