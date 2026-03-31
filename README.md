The only reason that this is public is so that I can fetch the files easily. Not really intended for use by others. But feel free to have a look around.

# Linux

```bash
curl -o- https://thisrepo/init.sh | bash
```

# Windows

## Terminal

Press `Ctrl+,` to open the settings. Click on the gear icon in the bottom left corner to open the settings file. Then just copy/paste `win/terminal-settings.json`.

### WSL

Add `export LS_COLORS="ow=30;101:tw=30;101"` to the `~/.bashrc` or `~/.zshrc` file. Otherwise, directories with dangerous permissions will look awful.
