# SSH

## Host configuration
Per-host settings are split into separate files under `~/.ssh/hosts/` and
included via `Include hosts/*.conf` at the top of `~/.ssh/config`. Add new
host entries there rather than directly in the main config.

## Tagged profiles
`Match tagged {tag}` blocks define option sets that apply only when requested
with `ssh -P {tag}` (OpenSSH 9.4+). They sit above the `Include` so they win
over host and default settings.

| Tag         | Effect                                                    |
| ----------- | --------------------------------------------------------- |
| `ephemeral` | Skip `known_hosts` reads and writes, and session sharing  |
| `password`  | Force password authentication, and skip session sharing   |

Because tags are plain SSH config, they work with any tool that runs `ssh`:

```sh
ssh -P ephemeral host
scp -o Tag=ephemeral file host:     # scp uses -P for the port
rsync -e 'ssh -P ephemeral' src host:dst
GIT_SSH_COMMAND='ssh -P password' git fetch
```

Only one tag applies per connection. The `essh` and `pssh` aliases in
`.bashrc` are shorthand for the two tags.

`ephemeral` disables host key verification, so it offers no protection
against a man-in-the-middle. Use it only for hosts where that is acceptable.

## Key confirmation
`AddKeysToAgent confirm` applies when SSH loads a key from a file on disk to
authenticate. The key is added to the agent with the confirm flag, requiring
explicit approval each time it is used. Keys added by an agent manager like
KeePassXC are unaffected — those are controlled by the manager itself.

## Connection multiplexing
`ControlMaster auto`, `ControlPath`, and `ControlPersist` together enable SSH
connection multiplexing: subsequent connections to the same host reuse an
existing authenticated session rather than opening a new one.

The control socket is stored at `~/.ssh/sessions/control-%C`, where `%C` is a
hash of the connection parameters. The `~/.ssh/sessions/` directory must exist
before multiplexing will work:

```sh
mkdir -p ~/.ssh/sessions
```
