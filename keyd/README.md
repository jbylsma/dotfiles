# keyd configurations

[keyd](https://github.com/rvaiya/keyd)

## Install

```sh
apt install keyd
install -Dm644 thinkpad-t16.conf /etc/keyd/thinkpad-{model}.conf
keyd.rvaiya reload
```

## Verify

```sh
keyd.rvaiya monitor
```

## Identifying keyboard IDs

The `[ids]` section matches devices by `vendor:product` in hex. Both
configs target `0001:0001`, the internal "AT Translated Set 2 keyboard",
so external USB and Bluetooth keyboards are left untouched.

To discover the ID of another keyboard, either run
`sudo keyd.rvaiya monitor` and press a key (each event line is prefixed
with its `vendor:product` ID), or match the device's `N: Name=` line to
the `Vendor`/`Product` fields just above it in
`/proc/bus/input/devices`.
