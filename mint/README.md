## Make Google Drive connect on login

- Connect files via "online accounts".
- Add this as a startup program: `nemo "google-drive://<email address>/"`

## SSH Forwarding (dev containers)

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

Only polkit rules

```js
polkit.addRule(function (action, subject) {
  // Only auto-approve for a real, locally logged-in admin session.
  if (!(subject.local && subject.active && subject.isInGroup("sudo"))) {
      return;
  }

  const allowedPrefixes = [
    "com.linuxmint.", // Mint Update Manager
    "org.aptkit.", // aptkit / aptdaemon (Mint's backend)
    "org.freedesktop.packagekit.", // PackageKit
    "org.freedesktop.Flatpak.",
    "org.gtk.vfs.file-operations", // nemo
    "in.teejeetech.pkexec.timeshift"
  ];
  return allowedPrefixes.some(function (prefix) {
    return action.id.indexOf(prefix) === 0;
  })
    ? polkit.Result.YES
    : polkit.Result.UNHANDLED;
});
```
