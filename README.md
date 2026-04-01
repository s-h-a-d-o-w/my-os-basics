The only reason that this is public is so that I can fetch the files easily. Not really intended for use by others. But feel free to have a look around.

# Linux

```bash
curl -o- https://raw.githubusercontent.com/s-h-a-d-o-w/my-os-basics/refs/heads/main/init.sh | bash
```

# Windows

## Terminal

Press `Ctrl+,` to open the settings. Click on the gear icon in the bottom left corner to open the settings file. Then just copy/paste `win/terminal-settings.json`.

# dev containers

## Windows

ONLY USE LINUX-BASED IMAGES WITH WSL-BASED FILES!!

Might be needed to enable SSH key usage (for the built-in git UI in code/cursor/...) in dev containers. Run the following **in an admin PowerShell terminal**:

```powershell
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
Get-Service ssh-agent
ssh-add
```
