## Make Google Drive connect on login

- Connect files via "online accounts".
- Add this as a startup program: `nemo "google-drive://<email address>/"`

## Prevent sudo prompts temporarily

### sudo

- `sudo visudo`
- Add at the bottom: `<username> ALL=(ALL) NOPASSWD: ALL`

### polkit

- Create e.g. `silence.rules` in `/etc/polkit-1/rules.d`.
- Use this code to suppress all promps:
```
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("sudo")) {
        return polkit.Result.YES;
    }
});
```

## More reasonable sudo prompts longterm

WIP
