# Kinesis Advantage2 custom layout

This directory contains the Kinesis Advantage2 custom layout that I use, as well
as instructions to programmatically load them via the Advantage2's v-Drive.

Instructions were made against the following Kinesis version and firmware, as
found in the `version.txt` file on the v-Drive:

```
Model name: Advantage2 Keyboard
Firmware version: 1.0.431.us (2MB), 11/14/2017
Bootloader version: 1.0.0
```

There is no guarantee that they will work on other firmware versions.

## Layout

The custom layout exists in a commented version of `qwerty.txt` in this
directory.

The remapping syntax is `[location]>[action]`, where `location` is the pressed
key and `action` is the desired action.

Changes that impact the keypad layer are prefixed with `kp-`.

All comments in the layout should be removed before being loaded, which can be
done with the awk script in `prepare-mapping`. The Advantage2 will attempt to
filter out comments but I had issues where the layout was silently rejected
because of comment parsing and found it easier to clean the loaded configuration
beforehand.

## Install

Loading via the v-Drive requires "Power User Mode" to be enabled. "Power User
Mode" can be toggled by holding `progm` and `Shift` and pressing `Esc`.

To load this layout:

1. Switch to the Windows thumb key mode (`progm+F7`)
2. Mount the Kinesis virtual drive `(progm+F1`)
3. Run `./prepare-mapping <qwerty.txt >/{Kinesis mount point}/active/qwerty.txt`
4. Unmount the Kinesis virtual drive (`progm+F1`)

## Thumb Key Mappings

The Advantage2's stock hardware thumb key layout is as follows:

```
 ------ -----     --------- ------
| Ctrl | Alt |   | Windows | Ctrl |
 ------ -----     --------- ------
 ```

The Advantage2 supports remapping the thumb keys via thumb key modes. The
three thumb key modes are:

* Mac
* Windows
* PC

The Windows thumb key mode is the default. When it is enabled, the Advantage2
has no additional key mappings.

When either the Mac or PC modes are activated, the Advantage2 adds custom
software key mappings. Changing to these mode will overwrite the custom layout,
as well as unbind the `scroll` key. Therefore, it is necessary to reload the
layout if the thumb key mode has been switched.
