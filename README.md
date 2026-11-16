# dotfiles

Shell, git, Vim, tmux, and desktop configuration, managed with
[chezmoi](https://www.chezmoi.io/).

Supported hosts: RHEL 8 and 9, and Debian 13. RHEL 7 hosts stay on the frozen
`stow` branch, which keeps the old GNU Stow layout.

## Install

```sh
git clone https://github.com/jbylsma/dotfiles.git ~/.local/share/chezmoi
~/.local/share/chezmoi/misc/bootstrap
```

The clone uses HTTPS, so pulling and `chezmoi update` need no credentials. The
git config pushes repos under `github.com/jbylsma` over SSH instead, so
pushing needs a GitHub key or your agent forwarded with `ssh -A`.

`bootstrap` downloads the pinned chezmoi release to `~/.local/bin`, checks its
SHA-256, then runs `chezmoi init --apply`. It asks for this host's role:

- `workstation`: everything, including the Regolith desktop, Alacritty, and
  tmux plugins
- `server`: shell, git, Vim, and tmux config, with Vim's plugins

Options:

| Option               | Effect                                             |
| -------------------- | -------------------------------------------------- |
| `--role server`      | Answer the role prompt                             |
| `--role workstation` | Answer the role prompt                             |
| `--yes`              | Overwrite existing files, such as skel `~/.bashrc` |

## Layout

| Path    | Contents                                                      |
| ------- | ------------------------------------------------------------- |
| `home/` | chezmoi's source state, deployed to `$HOME`                   |
| `misc/` | `bootstrap`, which isn't deployed                             |
| `keyd/` | System keyboard config, installed separately (see its README) |
| `ssh/`  | An example `~/.ssh/config` (see its README)                   |

`.chezmoiroot` makes `home/` the source directory, so only it reaches `$HOME`.

## Day to day

| Task                        | Command                                |
| --------------------------- | -------------------------------------- |
| Edit a managed file         | `chezmoi edit --apply ~/.bashrc`       |
| See what would change       | `chezmoi diff`                         |
| Keep a change made in place | `chezmoi re-add ~/.bashrc`             |
| Pull and apply from GitHub  | `chezmoi update`, or `terminal-update` |
| Open a shell in the repo    | `chezmoi cd`                           |

Deployed files are copies, so edit the repo's copy, then apply. Commit and
push from the repo as usual.

## Host-local files

These aren't managed, so each host can keep its own:

| File                         | Use                                     |
| ---------------------------- | --------------------------------------- |
| `~/.profile.local`           | Environment variables, in POSIX sh      |
| `~/.bashrc.local`            | Interactive bash settings               |
| `~/.config/git/config.local` | git identity and per-directory settings |

`~/.profile` is sourced by the graphical login under `/bin/sh`, so it and
`~/.profile.local` must stay POSIX.

Hand-installed tools can live in `~/.local/bin` beside the repo's scripts.
chezmoi leaves files it doesn't manage alone.

## Per-host differences

- `home/.chezmoiignore` skips the desktop files on servers. It also deploys
  the RHEL and Debian package scripts only where `/etc/redhat-release` or
  `/etc/debian_version` exists.
- `home/.chezmoiexternal.toml.tmpl` lists third-party downloads. vim-plug
  goes to every host, and the rest to workstations only.

## Pinned downloads

Everything the repo downloads is pinned to a version and checked against a
SHA-256 before use.

- chezmoi: in
  `home/.chezmoiscripts/run_onchange_before_install-chezmoi.sh`
- vim-plug, tmux-resurrect, and bemoji: in `home/.chezmoiexternal.toml.tmpl`

To bump chezmoi, change the version and both hashes in the installer script,
taking them from the release's `checksums.txt`. Each host installs it on its
next `chezmoi update`.

To bump an external, change the tag or commit in its URL and run
`chezmoi apply`. It fails with `SHA256 mismatch: expected <old>, got <new>`.
Check the new hash against your own download before pasting it in.

Vim plugins themselves aren't pinned. A `run_onchange_` script installs
missing plugins when `vimrc` changes, and `terminal-update vim` updates them.
