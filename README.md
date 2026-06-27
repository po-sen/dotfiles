# Posen's dotfiles

This repository helps me set up and maintain my Mac.

## Sync
```bash
make sync
```
This auto-detects a stable per-device fingerprint, uses a file like
`brewfiles/mac-xxxxxxxxxxxx.rb`, and creates it from `brewfiles/default.rb`
if missing. It also keeps `.tool-versions` pointed at a matching
`tool-versions/mac-xxxxxxxxxxxx`, created from `tool-versions/default` if
needed. Files under `home/` are linked into `~/` as dotfiles. The repo-managed
Ghostty config at `app-config/ghostty` is linked into
`~/.config/ghostty/config`. It will install Homebrew first if Homebrew is
not already present, then ensure the login shell is the
Homebrew-installed bash after `brew bundle install` completes
(`/opt/homebrew/bin/bash` on Apple Silicon), using `sudo` when a shell change
is needed.

`make sync` also patches the local `~/.codex/config.toml` from
`app-config/codex-notifications.toml`. It does not own or store the full Codex
config, so machine-local project trust, model, plugin, and marketplace settings
stay in that local file.

`make teardown` removes those repo-managed Codex notification keys again while
leaving the rest of `~/.codex/config.toml` intact.

`make device` shows the current Mac profile and refreshes generated symlinks:
`brewfiles/current.rb` and `tool-versions/current`. These symlinks point at the
profile files used by this computer and are ignored by git.

## Update
```bash
make update
```
This writes the currently installed Homebrew packages back into this Mac's own
device file under `brewfiles/`. It requires an existing Homebrew installation.

## Teardown
```bash
make teardown
```
