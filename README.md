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

`make sync` and `make teardown` do not modify Codex or Claude Code settings.
The previously installed notification hooks have been retired. The old
`scripts/codex-notify` and `scripts/claude-notify` paths remain as silent
compatibility entry points, so existing hook registrations pointing at this
checkout stop producing sounds, popups, logs, and Ghostty session tracking as
soon as the checkout is updated. No `make sync` or `make teardown` is needed
to silence them. Other machines need their own checkout updated as well.

Existing local hook registrations are left in place but do nothing. If cleaning
them up manually, remove only commands referencing this repository's
`scripts/codex-notify` or `scripts/claude-notify` from `~/.codex/hooks.json` and
`~/.claude/settings.json`, plus a legacy top-level Codex `notify` entry if it
references `scripts/codex-notify`. Preserve unrelated hooks and settings.
The legacy `codex-notify` CLI wrapper still forwards non-hook arguments to Codex.

Generated `current` symlinks show which profile this Mac uses and are ignored
by git.

## Update
```bash
make update
```
This writes the currently installed Homebrew and Mac App Store packages back
into this Mac's own profile Brewfile under `brewfiles/`. It requires an
existing Homebrew installation. Mac App Store discovery depends on Spotlight;
if indexing is disabled, enable and rebuild it with `sudo mdutil -Eai on`, wait
for `mas list` to return the installed apps, then run `make update` again.

## Teardown
```bash
make teardown
```
