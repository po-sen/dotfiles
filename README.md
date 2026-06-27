# Posen's dotfiles

This repository helps me set up and maintain my Mac.

## Sync
```bash
make sync
```
This auto-detects a stable per-device fingerprint, creates profile files from
`brewfiles/default.rb` and `tool-versions/default` when needed, and refreshes
`brewfiles/current.rb` plus `tool-versions/current` to point at this Mac's
profile. Homebrew installs use `brewfiles/current.rb`, and `~/.tool-versions`
points at `tool-versions/current`. The root `Brewfile` only loads
`brewfiles/current.rb`; profile selection is handled by the Makefile.

Files under `home/` are linked into `~/` as dotfiles. The repo-managed
Ghostty config at `config/ghostty` is linked into
`~/.config/ghostty/config`. It will install Homebrew first if Homebrew is
not already present, then ensure the login shell is the
Homebrew-installed bash after `brew bundle install` completes
(`/opt/homebrew/bin/bash` on Apple Silicon), using `sudo` when a shell change
is needed.

`make sync` also patches the local `~/.codex/config.toml` from
`config/codex-notifications.toml`. It does not own or store the full Codex
config, so machine-local project trust, model, plugin, and marketplace settings
stay in that local file.

`make teardown` removes those repo-managed Codex notification keys again while
leaving the rest of `~/.codex/config.toml` intact.

Generated `current` symlinks show which profile this Mac uses and are ignored
by git.

## Update
```bash
make update
```
This writes the currently installed Homebrew packages back into this Mac's own
profile Brewfile under `brewfiles/`. It requires an existing Homebrew
installation.

## Teardown
```bash
make teardown
```
