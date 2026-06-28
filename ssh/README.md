# SSH

## Host configuration
Per-host settings are split into separate files under `~/.ssh/hosts/` and
included via `Include hosts/*.conf` at the top of `~/.ssh/config`. Add new
host entries there rather than directly in the main config.

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
