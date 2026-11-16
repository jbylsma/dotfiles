# chezmoi workflow

Day-to-day notes for the dotfiles on chezmoi. To move a host that's still on
GNU Stow, see [stow-migration.md](stow-migration.md).

## How it works

| Name           | Where                            | What it is              |
| -------------- | -------------------------------- | ----------------------- |
| Source state   | `~/.local/share/chezmoi` (repo)  | What files should be    |
| Target state   | `$HOME`                          | What's actually there   |
| Config         | `~/.config/chezmoi/chezmoi.toml` | This host's `role`      |
| State database | `~/.config/chezmoi/`             | What chezmoi wrote, ran |

- `chezmoi apply` reads the repo, renders templates for this host, compares
  the result with `$HOME`, and writes only the differences. Running it again
  changes nothing.
- Deployed files are **copies**, not links into the repo. Editing
  `~/.bashrc` directly doesn't change the repo. This is the main difference
  from Stow.
- The state database is how chezmoi notices you changed a deployed file since
  it last wrote it, so it can ask before overwriting.
- `.chezmoiroot` contains `home`, so only `home/` is deployed. `docs/`,
  `misc/`, `keyd/`, and `ssh/` stay out of `$HOME`.

## File names in the repo

Prefixes and suffixes say how a file is deployed, and they stack:

| In `home/`                   | Deploys as             | Meaning              |
| ---------------------------- | ---------------------- | -------------------- |
| `dot_bashrc`                 | `~/.bashrc`            | `dot_` becomes `.`   |
| `dot_config/git/config`      | `~/.config/git/config` | Directories too      |
| `dot_local/bin/executable_x` | `~/.local/bin/x`, 755  | Executable bit set   |
| `symlink_x`                  | `x`, a symlink         | File holds target    |
| `x.tmpl`                     | `x`, rendered          | A Go template        |
| `.chezmoiscripts/run_*`      | Not deployed; run      | Scripts, see below   |

`chezmoi source-path ~/.bashrc` shows which repo file produces a target, and
`chezmoi target-path <repo file>` does the reverse.

Special files used here:

- `.chezmoi.toml.tmpl`: asks "Host role" (`server` or `workstation`) at
  `chezmoi init`, and writes the answer to the config.
- `.chezmoiignore`: what this host skips. Servers skip the desktop files; a
  host skips the other OS family's scripts.
- `.chezmoiexternal.toml.tmpl`: pinned downloads. vim-plug goes to every
  host, and the rest to workstations only.
- `.chezmoiscripts/run_onchange_before_install-chezmoi.sh`: keeps the pinned
  chezmoi binary installed.

## Set up a new host

```sh
git clone https://github.com/jbylsma/dotfiles.git ~/.local/share/chezmoi
~/.local/share/chezmoi/misc/bootstrap
```

- `bootstrap` installs the pinned chezmoi, checking its SHA-256, then runs
  `chezmoi init --apply`.
- It asks for the role, and stops at each existing file that differs, such as
  a skel `~/.bashrc`, to ask whether to overwrite it.
- `--role server|workstation` answers the prompt. `--yes` overwrites without
  asking.

## Everyday commands

### Look before you write

| Command             | Shows                                             |
| ------------------- | ------------------------------------------------- |
| `chezmoi status`    | One line per file that differs, like `git status` |
| `chezmoi diff`      | What `apply` would change                         |
| `chezmoi apply -nv` | A dry run, listing every action                   |

`chezmoi status` has two columns. The first compares the target with what
chezmoi last wrote, so an entry there means it changed locally. The second
compares the target with the repo, so it's what `apply` would do. The letters
are `A` (add), `D` (delete), `M` (modify), and `R` (run a script).

### Change a managed file

Pick one habit and keep to it:

- `chezmoi edit --apply ~/.bashrc` opens the repo's copy, then applies it when
  the editor closes. Without `--apply`, only the repo changes.
- Or edit in the repo, then run `chezmoi apply`. `chezmoi cd` opens a shell in
  the repo; exit to come back.

Then commit and push from the repo, as with any git repo. `chezmoi git --
status` runs git there without changing directory.

### Start managing a file

```sh
chezmoi add ~/.config/foo/config         # copy it into the repo
chezmoi add --template ~/.config/foo/rc  # as a template, to add host logic
```

New workstation-only files also need a line in `.chezmoiignore`, or servers
get them too.

### A deployed file changed locally

This happens when you edit `~/.foo` directly, or an app rewrites its config.

| You want                     | Run                                        |
| ---------------------------- | ------------------------------------------ |
| Keep the local change        | `chezmoi re-add ~/.foo`, then commit       |
| Throw it away                | `chezmoi apply ~/.foo`                     |
| Combine it with repo changes | `chezmoi merge ~/.foo` (three-way vimdiff) |
| Review every changed file    | `chezmoi merge-all`                        |

`re-add` skips templates. For a `.tmpl` file, make the change in the repo.

Claude Code rewrites `~/.claude/settings.json` when you change a setting, so
check `chezmoi status` after changing one, and `re-add` what you want to keep.

### Pull changes from other hosts

```sh
chezmoi update                # git pull --ff-only in the repo, then apply
chezmoi update --apply=false  # pull only; review with chezmoi diff
```

`terminal-update` runs `chezmoi update`.

- The pull is fast-forward only. Uncommitted edits to files it changes, or
  unpushed commits, stop it before anything is applied. Commit or stash, then
  run it again.
- If a file was changed locally since chezmoi last wrote it, chezmoi stops and
  asks: overwrite, skip, or show a diff.

### Stop managing, or delete

| Command                  | Effect                                   |
| ------------------------ | ---------------------------------------- |
| `chezmoi forget ~/.foo`  | Remove it from the repo; leave the file  |
| `chezmoi destroy ~/.foo` | Remove it from the repo and from `$HOME` |

Deleting a file from the repo doesn't delete it on other hosts; chezmoi only
stops managing it. To remove it everywhere, list its path in
`home/.chezmoiremove` too.

## Files chezmoi doesn't manage

chezmoi only touches what's in the repo. Everything else in `$HOME` is left
alone, so these are safe:

- **Hand-installed tools** in `~/.local/bin`, such as `composer`, `yt-dlp`,
  `hugo`, and `git-filter-repo`. They sit beside the repo's scripts.
  `chezmoi unmanaged ~/.local/bin` lists them.
- **Host-local config,** sourced or included by managed files:
  - `~/.bashrc.local`: interactive bash settings, such as `CDPATH`
  - `~/.profile.local`: environment variables, in POSIX sh
  - `~/.config/git/config.local`: git identity and per-directory settings

Never give `dot_local/bin`, or any other shared directory, the `exact_`
prefix. `exact_` deletes everything chezmoi doesn't manage in that directory,
including hand-installed tools.

If the repo ever adds a file with the same name as an unmanaged one, chezmoi
sees the existing file and asks before overwriting it.

## Per-host differences

From simplest to most involved:

1. **`.chezmoiignore`:** don't deploy a file on some hosts. It's a template:
   ```text
   {{ if ne .role "workstation" }}
   .config/regolith3
   {{ end }}
   ```
2. **Templates (`.tmpl`):** one file whose content varies by host.
3. **Host-local files:** settings that belong to one host only. See above.

Inputs a template can use:

- `.role`, from the "Host role" prompt
- built-in values: `.chezmoi.homeDir`, `.chezmoi.hostname`,
  `.chezmoi.osRelease.id`, `.chezmoi.workingTree`
- functions such as `stat`, `lookPath`, and `joinPath`

Don't use `.chezmoi.group`, `.chezmoi.uid`, or `.chezmoi.gid`. With IdM
accounts on RHEL they come back empty, without an error.

Testing templates:

| Command                                  | Shows                         |
| ---------------------------------------- | ----------------------------- |
| `chezmoi data`                           | Every value templates can use |
| `chezmoi execute-template '{{ .role }}'` | The result of one expression  |
| `chezmoi cat ~/.bashrc`                  | A rendered file, unwritten    |

To change a host's role, edit `~/.config/chezmoi/chezmoi.toml`, or run
`chezmoi init --prompt` to answer the prompt again.

## Scripts

Scripts in `home/.chezmoiscripts/` run during `apply`, rather than being
deployed:

| Prefix          | Runs                                   |
| --------------- | -------------------------------------- |
| `run_`          | Every `apply`                          |
| `run_once_`     | Once per unique content, per host      |
| `run_onchange_` | Whenever its content changes, per host |

- `before_` or `after_` in the name sets whether it runs before or after files
  are written.
- chezmoi records a hash of each `run_once_` and `run_onchange_` script in its
  state database. To force a rerun, clear the record with
  `chezmoi state delete-bucket --bucket=scriptState`.

### The chezmoi installer

`run_onchange_before_install-chezmoi.sh` holds the chezmoi version and its
SHA-256 for amd64 and arm64. It runs:

- directly from `bootstrap`, before chezmoi exists
- on the first `apply` after that, as a no-op, because the version matches
- whenever its contents change, which is normally a pin bump

It exits at once if the installed chezmoi already matches the pin, so an
extra run, such as after a comment edit, is harmless.

## Pinned downloads

Everything the dotfiles download is pinned to a version and checked against a
SHA-256 before use. No `curl | sh`, and no `chezmoi upgrade`.

### Bump chezmoi

1. Read the release notes.
2. In the installer script, change `CHEZMOI_VERSION` and both hashes. Take the
   hashes for `chezmoi_<version>_linux-musl_amd64.tar.gz` and
   `chezmoi_<version>_linux_arm64.tar.gz` from the release's `checksums.txt`,
   and check them against your own download.
3. Run `chezmoi apply` here, then `chezmoi --version`.
4. Commit and push. Other hosts install it on their next `chezmoi update`.

### Bump an external

The externals are vim-plug, tmux-resurrect, and bemoji, in
`.chezmoiexternal.toml.tmpl`.

1. Change the version, tag, or commit in its URL.
2. Run `chezmoi apply`. It fails with
   `SHA256 mismatch: expected <old>, got <new>`.
3. Check the new hash against your own download of the same URL, then paste
   it into `checksum.sha256`.
4. Test, then commit and push.

A changed URL always downloads fresh. `refreshPeriod` isn't set, so an
unchanged URL is never downloaded again. `chezmoi apply -R` forces every
external to download again, and the checksums are checked again.

## Troubleshooting

| Command             | Use                                        |
| ------------------- | ------------------------------------------ |
| `chezmoi doctor`    | Checks the setup and environment           |
| `chezmoi managed`   | Every target chezmoi manages on this host  |
| `chezmoi ignored`   | What `.chezmoiignore` skipped on this host |
| `chezmoi unmanaged` | Files in `$HOME` chezmoi doesn't manage    |
| `chezmoi verify`    | Exits 1 if anything differs from the repo  |

## Habits to unlearn from Stow

- A deployed file is a copy. Edit the repo copy with `chezmoi edit`, or
  `re-add` after editing in place.
- A new file isn't live until `chezmoi apply`, and isn't on other hosts until
  you push and they run `chezmoi update`.
- Removing a file from the repo doesn't remove it from `$HOME`. Use
  `chezmoi destroy`, or `.chezmoiremove` for every host.
