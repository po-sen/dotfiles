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

.PHONY: help install update uninstall

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

install: $(DOTFILES) $(VIM_PLUGS) ## Install Brewfile packages, Vim plugins, and asdf tools
	@if [ ! -x "$(BREW)" ]; then /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; fi
	@$(BREW) bundle install --file="$(ROOT)/Brewfile" --force --cleanup
	@$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall
	@set -eu; \
		awk 'NF && $$1 !~ /^#/ { print $$1 }' "$(HOME)/.tool-versions" | while IFS= read -r plugin; do \
			$(ASDF) plugin list | grep -Fxq "$$plugin" || $(ASDF) plugin add "$$plugin"; \
		done; \
		$(ASDF) install

update: $(DOTFILES) $(VIM_PLUGS) ## Update Brewfile packages, Vim plugins, and asdf tools
	@$(BREW) update
	@$(BREW) bundle install --file="$(ROOT)/Brewfile" --force --cleanup
	@$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall
	@set -eu; \
		awk 'NF && $$1 !~ /^#/ { print $$1 }' "$(HOME)/.tool-versions" | while IFS= read -r plugin; do \
			$(ASDF) plugin list | grep -Fxq "$$plugin" || $(ASDF) plugin add "$$plugin"; \
		done; \
		$(ASDF) install

uninstall: ## Remove repo-managed dotfiles plus Vim and asdf state
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
