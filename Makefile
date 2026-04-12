SHELL := /bin/sh

ifeq ($(shell /usr/bin/uname -m),arm64)
HOMEBREW_PREFIX ?= /opt/homebrew
else
HOMEBREW_PREFIX ?= /usr/local
endif

ROOT := $(CURDIR)
CONFIG_DIR := $(ROOT)/config
CONFIG_FILES := $(wildcard $(CONFIG_DIR)/*)
CONFIG_LINKS := $(patsubst $(CONFIG_DIR)/%,$(HOME)/.%,$(CONFIG_FILES))

BREW := $(HOMEBREW_PREFIX)/bin/brew
NVIM := $(HOMEBREW_PREFIX)/bin/nvim
ASDF := $(HOMEBREW_PREFIX)/bin/asdf

DOTFILES := $(CONFIG_LINKS) $(HOME)/.vimrc $(HOME)/.config/nvim/init.vim $(HOME)/.tool-versions
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

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*## "; print "Available targets:"} /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

$(HOME)/.%: $(CONFIG_DIR)/%
	@ln -sf $< $@

$(HOME)/.vimrc $(HOME)/.config/nvim/init.vim: $(ROOT)/vimrc
	@mkdir -p $(dir $@)
	@ln -sf $< $@

$(VIM_PLUGS):
	@curl --silent --create-dirs -fLo $@ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(HOME)/.tool-versions: $(ROOT)/tool-versions
	@ln -sf $< $@

sync: $(DOTFILES) $(VIM_PLUGS) ## Apply this device's Brewfile to the current machine
	@$(ENSURE_BREW)
	@$(BREW) bundle install --file="$(ROOT)/Brewfile" --force --cleanup
	@if [ ! -x "$(NVIM)" ]; then echo "Neovim is not installed at $(NVIM). Run 'make sync' again after brew sync completes, or install neovim in your device Brewfile." >&2; exit 1; fi
	@$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall
	@if [ ! -x "$(ASDF)" ]; then echo "asdf is not installed at $(ASDF). Add 'brew \"asdf\"' to this device Brewfile or run brew sync again after fixing Homebrew state." >&2; exit 1; fi
	@set -eu; \
		awk 'NF && $$1 !~ /^#/ { print $$1 }' "$(HOME)/.tool-versions" | while IFS= read -r plugin; do \
			$(ASDF) plugin list | grep -Fxq "$$plugin" || $(ASDF) plugin add "$$plugin"; \
		done; \
		$(ASDF) install

update: ## Write installed Homebrew packages back to this device's Brewfile
	@if [ ! -x "$(BREW)" ]; then echo "Homebrew is not installed at $(BREW). 'make update' requires an existing Homebrew installation to dump installed packages." >&2; exit 1; fi
	@device_file="$$(/usr/bin/ruby -e 'load "$(ROOT)/Brewfile"; print ensure_device_brewfile!')"; \
	$(BREW) bundle dump --file="$$device_file" --force --brews --casks --taps --vscode

teardown: ## Remove repo-managed dotfiles plus Vim and asdf state
	@for file in $(CONFIG_FILES); do \
		rm -f "$(HOME)/.$$(basename "$$file")"; \
	done
	@$(RM) "$(HOME)/.vimrc" "$(HOME)/.tool-versions"
	@$(RM) -r "$(HOME)/.vim" "$(HOME)/.config/nvim"
	@if [ -x "$(ASDF)" ]; then \
		$(ASDF) plugin list | while IFS= read -r plugin; do \
			[ -n "$$plugin" ] || continue; \
			$(ASDF) plugin remove "$$plugin"; \
		done; \
	fi
