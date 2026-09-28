# Quickshell Desktop Shell

A small Quickshell configuration for CachyOS and Hyprland. It provides a translucent top bar on each display, a centered media/volume island, an unframed StatusNotifier tray, and audio, Ethernet, and Bluetooth controls.

## Run

```sh
quickshell --path /home/mateoleal/Projects/shell/shell.qml
```

The equivalent short option is `-p`. Quickshell also accepts a config directory:

```sh
quickshell -p /home/mateoleal/Projects/shell
```

To install as a named user config, link this directory to `~/.config/quickshell/shell` and run `quickshell -c shell`.

## Requirements

- Quickshell 0.3.1 or later with the Hyprland, PipeWire, MPRIS, StatusNotifier, and Bluetooth QML modules.
- Hyprland IPC available in the current session.
- NetworkManager (`nmcli`) for Ethernet link status.
- PipeWire for volume controls; BlueZ for Bluetooth controls.
- A media player exporting MPRIS for media controls.

The bars and island are instantiated for every connected display. The tray has no tray-specific backdrop. The shell does not replace the wallpaper service, launcher, or session startup configuration.

## Matugen palette

Matugen generates `services/ShellPalette.qml` from the Material You scheme of a wallpaper image. Wallpaper changes are disabled in `matugen/config.toml`, so generation only updates the shell palette. A starter palette is generated from the configured fallback color.

```sh
matugen image /path/to/wallpaper.png --config /home/mateoleal/Projects/shell/matugen/config.toml --mode dark --type scheme-expressive --source-color-index 0
```

Palette colors are consumed through `services/Theme.qml`, which also owns the shell's font families, sizes, spacing, dimensions, radii, and opacity tokens. Components should use `Theme` rather than hard-coded style values.

## Notification ownership

`notificationsEnabled` in `shell.qml` defaults to `false`. This machine currently has another shell owning the notification and StatusNotifier DBus services. Only one host can own each service at a time, so disable that shell's tray/notification services (or stop it) before setting `notificationsEnabled` to `true`. The config does not stop or reconfigure another shell automatically.

## Optional Hypr ecosystem tools

These are not runtime dependencies and are not wired into the initial UI:

- `hyprlauncher` opens the Hyprland launcher.
- `hyprpicker -a` picks a color and copies it when `wl-clipboard` is available.
- `hyprctl hyprpaper listactive` reports active wallpapers; see the [hyprpaper documentation](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/) for wallpaper commands.

## Smoke check

1. Run the command above and check the terminal for QML import, binding, or DBus ownership errors.
2. Confirm bar placement on both displays and switch workspaces on each monitor.
3. Start an MPRIS-compatible media player and verify its title and play/pause control in the island.
4. Open Controls and test volume, Ethernet status, Bluetooth, and output-device selection.
5. Verify tray icon activation after the existing StatusNotifier host is disabled.
6. To test notifications, release the existing notification service name, set `notificationsEnabled` to `true`, and reload Quickshell.