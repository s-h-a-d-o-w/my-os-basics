## Make Google Drive connect on login

- Connect files via "online accounts".
- Add this as a startup program: `nemo "google-drive://<email address>/"`

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

## Prevent sudo prompts temporarily

... OR JUST INSTALL GAZE RIGHT AWAY!

### sudo

- `sudo visudo`
- Add at the bottom: `<username> ALL=(ALL) NOPASSWD: ALL`

### polkit

- Create e.g. `silence.rules` in `/etc/polkit-1/rules.d`.
- Use this code to suppress all promps:
```js
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("sudo")) {
        return polkit.Result.YES;
    }
});
```

## More reasonable sudo prompts longterm

- Use gaze but [disabling it on the login screen for keyring unlocking](https://gaze.gundulabs.com/guide/lightdm.html#turning-it-off)!
- Remove possible temporary setup rules described above
