## Terminal

Press `Ctrl+,` to open the settings. Click on the gear icon in the bottom left corner to open the settings file. Then just copy/paste `terminal-settings.json`.

## SSH Agent forwarding for dev containers

ONLY USE LINUX-BASED IMAGES WITH WSL-BASED FILES!!

Might be needed to enable SSH key usage (for the built-in git UI in code/cursor/...) in dev containers. Run the following **in an admin PowerShell terminal**:

```powershell
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
Get-Service ssh-agent
ssh-add
```
