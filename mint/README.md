## Best sudo prompt UX

- [gaze](https://github.com/GunduLabs/gaze) - [disable it on the login screen for keyring unlocking](https://gaze.gundulabs.com/guide/lightdm.html#turning-it-off)!

## Essential tools

- gear lever (yaak, WayVR, LeShade, LosslessCut, GPU-T)
- flatseal
- mission center
- resources
- k3b
- meld
- ncdu
- simplescreenrecorder

## Startup entries

- `flatpak update -y`
- `nemo "google-drive://<email address>/"` (see "Make Google Drive connect on login")

## Make Google Drive connect on login

- Connect files via "online accounts".
- Add this as a startup program, so that mounting happens: `nemo "google-drive://<email address>/"`

## Disable USB autosuspend

Add this to boot parameters in "System Administration": `usbcore.autosuspend=-1`

## Limit mpv to 100% volume, among other things (Don't bother with celluloid)

See `mpv.conf`.

## SSH Forwarding (for devcontainers)

```bash
# ~/.profile
eval "$(ssh-agent -s)"
ssh-add 2> /dev/null
```

Confirm with:

```bash
ssh -T git@github.com
```

## Extract AppImage icons

```bash
./<app>.AppImage --appimage-extract >/dev/null 2>&1 && find squashfs-root -type f \( -iname '*.png' -o -iname '*.svg' -o -iname '*.xpm' \) | grep -Ei 'icon|logo|app' | head -n 20
```
