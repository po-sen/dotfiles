SHELL := /bin/sh

ifeq ($(shell /usr/bin/uname -m),arm64)
HOMEBREW_PREFIX ?= /opt/homebrew
else
HOMEBREW_PREFIX ?= /usr/local
endif

ROOT := $(CURDIR)
CONFIG_DIR := $(ROOT)/config
GHOSTTY_CONFIG_SOURCE := $(CONFIG_DIR)/ghostty
CODEX_NOTIFICATION_CONFIG := $(CONFIG_DIR)/codex-notifications.toml
CONFIG_FILES := $(filter-out $(GHOSTTY_CONFIG_SOURCE) $(CODEX_NOTIFICATION_CONFIG),$(wildcard $(CONFIG_DIR)/*))
CONFIG_LINKS := $(patsubst $(CONFIG_DIR)/%,$(HOME)/.%,$(CONFIG_FILES))
GHOSTTY_CONFIG_LINK := $(HOME)/.config/ghostty/config

BREW := $(HOMEBREW_PREFIX)/bin/brew
HOMEBREW_BASH := $(HOMEBREW_PREFIX)/bin/bash
NVIM := $(HOMEBREW_PREFIX)/bin/nvim
ASDF := $(HOMEBREW_PREFIX)/bin/asdf
BREW_BUNDLE_FLAGS ?= --force --cleanup
BREW_DUMP_FLAGS ?= --force --brews --casks --taps --vscode

DOTFILES := $(CONFIG_LINKS) $(GHOSTTY_CONFIG_LINK) $(HOME)/.vimrc $(HOME)/.config/nvim/init.vim
VIM_PLUGS := $(HOME)/.vim/autoload/plug.vim $(HOME)/.config/nvim/autoload/plug.vim

.DEFAULT_GOAL := help

.PHONY: help sync update teardown

define ENSURE_BREW
if [ ! -x "$(BREW)" ]; then \
	echo "Homebrew is not installed. Installing Homebrew first..."; \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
fi; \
if [ ! -x "$(BREW)" ]; then \
	echo "Homebrew install did not create $(BREW)." >&2; \
	exit 1; \
fi
endef

define ENSURE_PRIMARY_BASH
if [ ! -x "$(HOMEBREW_BASH)" ]; then \
	echo "Homebrew bash is not installed at $(HOMEBREW_BASH). Add 'brew \"bash\"' to this device Brewfile and run 'make sync' again." >&2; \
	exit 1; \
fi; \
username="$$(id -un)"; \
current_shell="$$(dscl . -read /Users/$$username UserShell 2>/dev/null | awk 'END { print $$2 }')"; \
if [ -z "$$current_shell" ]; then \
	current_shell="$${SHELL:-}"; \
fi; \
if [ "$$current_shell" != "$(HOMEBREW_BASH)" ]; then \
	if ! grep -Fxq "$(HOMEBREW_BASH)" /etc/shells; then \
		echo "Adding $(HOMEBREW_BASH) to /etc/shells (sudo may prompt for your password)..."; \
		printf '%s\n' "$(HOMEBREW_BASH)" | sudo tee -a /etc/shells >/dev/null; \
	fi; \
	echo "Changing login shell for $$username to $(HOMEBREW_BASH) (sudo may prompt for your password)..."; \
	sudo chsh -s "$(HOMEBREW_BASH)" "$$username"; \
fi
endef

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*## "; print "Available targets:"} /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

$(HOME)/.%: $(CONFIG_DIR)/%
	@ln -sf $< $@

$(GHOSTTY_CONFIG_LINK): $(GHOSTTY_CONFIG_SOURCE)
	@mkdir -p $(dir $@)
	@ln -sf $< $@

$(HOME)/.vimrc $(HOME)/.config/nvim/init.vim: $(ROOT)/vimrc
	@mkdir -p $(dir $@)
	@ln -sf $< $@

$(VIM_PLUGS):
	@curl --silent --create-dirs -fLo $@ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sync: $(DOTFILES) $(VIM_PLUGS) ## Apply this device's Brewfile and tool versions to the current machine
	@$(ROOT)/scripts/sync-codex-config
	@tool_versions_file="$$(/usr/bin/ruby -e 'load "$(ROOT)/Brewfile"; print ensure_device_tool_versions!')"; \
		ln -sfn "$$tool_versions_file" "$(HOME)/.tool-versions"
	@$(ENSURE_BREW)
	@device_file="$$(/usr/bin/ruby -e 'load "$(ROOT)/Brewfile"; print ensure_device_brewfile!')"; \
		test -f "$$device_file"; \
		$(BREW) bundle install --file="$$device_file" $(BREW_BUNDLE_FLAGS)
	@$(ENSURE_PRIMARY_BASH)
	@if [ ! -x "$(NVIM)" ]; then echo "Neovim is not installed at $(NVIM). Run 'make sync' again after brew sync completes, or install neovim in your device Brewfile." >&2; exit 1; fi
	@$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall >/dev/null 2>&1
	@if [ ! -x "$(ASDF)" ]; then echo "asdf is not installed at $(ASDF). Add 'brew \"asdf\"' to this device Brewfile or run 'make sync' again after fixing Homebrew state." >&2; exit 1; fi
	@set -eu; \
		awk 'NF && $$1 !~ /^#/ { print $$1 }' "$(HOME)/.tool-versions" | while IFS= read -r plugin; do \
			$(ASDF) plugin list | grep -Fxq "$$plugin" || $(ASDF) plugin add "$$plugin"; \
		done; \
		$(ASDF) install

update: ## Write installed Homebrew packages back to this device's Brewfile
	@if [ ! -x "$(BREW)" ]; then echo "Homebrew is not installed at $(BREW). 'make update' requires an existing Homebrew installation to dump installed packages." >&2; exit 1; fi
	@device_file="$$(/usr/bin/ruby -e 'load "$(ROOT)/Brewfile"; print ensure_device_brewfile!')"; \
	$(BREW) bundle dump --file="$$device_file" $(BREW_DUMP_FLAGS)

teardown: ## Remove repo-managed dotfiles plus Vim and asdf state
	@for file in $(CONFIG_FILES); do \
		rm -f "$(HOME)/.$$(basename "$$file")"; \
	done
	@rm -f "$(GHOSTTY_CONFIG_LINK)"
	@$(RM) "$(HOME)/.vimrc" "$(HOME)/.tool-versions"
	@$(RM) -r "$(HOME)/.vim" "$(HOME)/.config/nvim"
	@if [ -x "$(ASDF)" ]; then \
		$(ASDF) plugin list | while IFS= read -r plugin; do \
			[ -n "$$plugin" ] || continue; \
			$(ASDF) plugin remove "$$plugin"; \
		done; \
	fi
