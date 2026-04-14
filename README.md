# Posen's dotfiles

This repository helps me set up and maintain my Mac.

## Sync
```bash
make sync
```
This auto-detects a stable per-device fingerprint, uses a file like
`brewfiles/device-xxxxxxxxxxxx.rb`, and creates it from `brewfiles/default.rb`
if missing. It also keeps `.tool-versions` pointed at a matching
`tool-versions/device-xxxxxxxxxxxx`, created from `tool-versions/default` if
needed. It will install Homebrew first
if Homebrew is not already present, then ensure the login shell is the
Homebrew-installed bash after `brew bundle install` completes
(`/opt/homebrew/bin/bash` on Apple Silicon).

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
