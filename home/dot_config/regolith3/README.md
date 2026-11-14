# Required apt packages (2026-10-22)
```
i3xrocks-battery
i3xrocks-nm-vpn
i3xrocks-rofication
i3xrocks-volume
regolith-compositor-none
regolith-desktop
regolith-session-flashback
regolith-session-sway
ssh-askpass-gnome
```

# Other dependencies

Emoji picker: chezmoi installs a pinned
[bemoji](https://github.com/marty-oehme/bemoji) in `~/.local/opt/bemoji` on
workstations, and links it into `~/.local/bin`. To update it, bump its pin in
`home/.chezmoiexternal.toml.tmpl`.
