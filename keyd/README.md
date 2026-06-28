# keyd configurations

[keyd](https://github.com/rvaiya/keyd)

## Configurations

Configurations are composable — `default.conf` is the base; `install.sh`
merges in any applicable fragments.  keyd requires all bindings for a
device to live in a single `.conf` file, so the optional files are plain
key-binding fragments (no `[ids]` header) rather than standalone configs.

All bindings target `0001:0001`, the internal "AT Translated Set 2
keyboard", so external keyboards are left untouched.

| File                | Include when…                                        |
| ------------------- | ---------------------------------------------------- |
| `default.conf`      | Always — swaps Caps Lock/Esc, enables double-shift   |
| `copilot-super.conf`| Keyboard has a Microsoft Copilot key                 |
| `sysrq-super.conf`  | Print Screen is a standalone key (maps it to Super)  |

## Install

```sh
apt install keyd
# Base only:
sudo ./install.sh
# With Copilot key:
sudo ./install.sh copilot-super.conf
# With both Copilot key and standalone Print Screen:
sudo ./install.sh copilot-super.conf sysrq-super.conf
```

## Verify

```sh
keyd.rvaiya monitor
```

## Identifying keyboard IDs

The `[ids]` section matches devices by `vendor:product` in hex. All
configs target `0001:0001`, the internal "AT Translated Set 2 keyboard",
so external USB and Bluetooth keyboards are left untouched.

To discover the ID of another keyboard, either run
`sudo keyd.rvaiya monitor` and press a key (each event line is prefixed
with its `vendor:product` ID), or match the device's `N: Name=` line to
the `Vendor`/`Product` fields just above it in
`/proc/bus/input/devices`.
