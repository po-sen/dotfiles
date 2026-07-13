tap "homebrew/core"
tap "po-sen/tap", trusted: true
# Static analysis and lint tool, for (ba)sh scripts
brew "shellcheck"
# Static checker for GitHub Actions workflow files
brew "actionlint"
# Extendable version manager with support for Ruby, Node.js, Erlang & more
brew "asdf"
# Bourne-Again SHell, a UNIX command interpreter
brew "bash"
# Programmable completion for Bash 4.2+
brew "bash-completion@2"
# Programming language designed for robustness, optimality, and clarity
brew "zig"
# Compile Cargo project with zig as linker
brew "cargo-zigbuild"
# Container runtimes on MacOS (and Linux) with minimal setup
brew "colima", restart_service: :changed
# GNU File, Shell, and Text utilities
brew "coreutils"
# Pack, ship and run any application as a lightweight container
brew "docker"
# Docker CLI plugin for extended build capabilities with BuildKit
brew "docker-buildx"
# Isolated development environments using Docker
brew "docker-compose"
# Debian package management system
brew "dpkg"
# GNU awk utility
brew "gawk"
# Cryptography and SSL/TLS Toolkit
brew "openssl@3"
# Interact with Google Gemini AI models from the command-line
brew "gemini-cli"
# GitHub command-line tool
brew "gh"
# Distributed revision control system
brew "git"
# GNU Privacy Guard (OpenPGP)
brew "gnupg"
# Fast linters runner for Go
brew "golangci-lint"
# Kubernetes package manager
brew "helm"
# Improved top (interactive process viewer)
brew "htop"
# Lightweight and flexible command-line JSON processor
brew "jq"
# Kubernetes command-line interface
brew "kubernetes-cli"
# Postgres C API library
brew "libpq"
# Utility for directing compilation
brew "make"
# Sign files & verify signatures. Works with signify in OpenBSD
brew "minisign"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Open-source, cross-platform JavaScript runtime environment
brew "node@22"
# Package compiler and linker metadata toolkit
brew "pkgconf"
# Interpreted, interactive, object-oriented programming language
brew "python@3.14"
# Framework for managing multi-language pre-commit hooks
brew "pre-commit"
# Fast Git hook manager written in Rust, drop-in alternative to pre-commit
brew "prek"
# Develop and deploy code with zero configuration
brew "railway"
# Display directories as trees (with optional color/HTML output)
brew "tree"
# Executes a program periodically, showing output fullscreen
brew "watch"
# Internet file retriever
brew "wget"
# UNIX shell (command interpreter)
brew "zsh"
# Additional completion definitions for zsh
brew "zsh-completions"
# OpenAI's official ChatGPT desktop app
cask "chatgpt"
# OpenAI's coding agent that runs in your terminal
cask "codex"
# Universal database tool and SQL client
cask "dbeaver-community"
# Driver for the Flic bluetooth button
cask "flic"
# Terminal emulator that uses platform-native UI and GPU acceleration
cask "ghostty"
# Web browser
cask "google-chrome"
# Terminal emulator as alternative to Apple's Terminal app
cask "iterm2"
# Wallet desktop application to maintain multiple cryptocurrencies
cask "ledger-wallet"
# Move and resize windows using keyboard shortcuts or snap areas
cask "rectangle"
# Virtual machines UI using QEMU
cask "utm"
# Network monitoring and troubleshooting tool
cask "wifiman"
