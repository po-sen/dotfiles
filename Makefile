SHELL := /bin/bash
FILES :=

GIT ?= /usr/bin/git
CURL ?= /usr/bin/curl
SUDO ?= /usr/bin/sudo
BREW ?= /opt/homebrew/bin/brew
NVIM ?= /opt/homebrew/bin/nvim

.DEFAULT_GOAL := pull-remote
.PHONY: pull-remote
pull-remote: $(GIT)
	@$(GIT) config remote.origin.url git@github.com:Posen2101024/dotfiles.git
	@$(GIT) config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
	@$(GIT) fetch --force origin
	@$(GIT) reset --hard origin/master

FILES += $(HOME)/.vim/autoload/plug.vim
$(HOME)/.vim/autoload/plug.vim: $(CURL)
	@$(CURL) --silent --create-dirs -fLo $(HOME)/.vim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FILES += $(HOME)/.config/nvim/autoload/plug.vim
$(HOME)/.config/nvim/autoload/plug.vim: $(CURL)
	@$(CURL) --silent --create-dirs -fLo $(HOME)/.config/nvim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FILES += $(HOME)/.vimrc
$(HOME)/.vimrc:
	@ln -sf $(PWD)/vimrc $(HOME)/.vimrc

FILES += $(HOME)/.config/nvim/init.vim
$(HOME)/.config/nvim/init.vim:
	@ln -sf $(PWD)/vimrc $(HOME)/.config/nvim/init.vim

FILES += $(HOME)/.bash_profile
$(HOME)/.bash_profile:
	@ln -sf $(PWD)/bash_profile $(HOME)/.bash_profile

FILES += $(HOME)/.gitconfig
$(HOME)/.gitconfig:
	@ln -sf $(PWD)/gitconfig $(HOME)/.gitconfig

.PHONY: clean
clean:
	@rm -rf $(FILES)

.PHONY: prepare
prepare: $(FILES)

.PHONY: install-homebrew
install-homebrew: prepare $(CURL)
	@bash -c "$$($(CURL) -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: uninstall-homebrew
uninstall-homebrew: $(CURL) $(SUDO)
	@bash -c "$$($(CURL) -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	@$(SUDO) rm -rf /opt/homebrew/

.PHONY: install-brewfile
install-brewfile: prepare $(BREW)
	$(BREW) update
	$(BREW) bundle install --force
	$(BREW) list --versions

.PHONY: update-brewfile
update-brewfile: prepare $(BREW)
	$(BREW) update
	$(BREW) bundle install --force
	$(BREW) bundle dump --force
	$(BREW) list --versions

.PHONY: uninstall-brewfile
uninstall-brewfile:
	@set -euo pipefail; \
	BREW_LIST=$$($(BREW) bundle list --all); \
	if [[ -n "$$BREW_LIST" ]]; then \
		$(BREW) uninstall --force --ignore-dependencies $$BREW_LIST; \
	fi;

.PHONY: install-vim-plugins
install-vim-plugins: prepare $(NVIM)
	$(NVIM) --headless +"source snapshot.vim" +qall 2> /dev/null

.PHONY: update-vim-plugins
update-vim-plugins: prepare $(NVIM) $(GIT)
	$(NVIM) --headless +PlugUpgrade +PlugUpdate +"PlugSnapshot! snapshot.vim" +qall 2> /dev/null
	$(GIT) --no-pager diff --color snapshot.vim

.PHONY: uninstall-vim-plugins
uninstall-vim-plugins:
	@rm -rf $(HOME)/.vim/plugged/*

.PHONY: all
all: install-homebrew install-brewfile install-vim-plugins

.PHONY: update
update: update-brewfile update-vim-plugins

.PHONY: clean-all
clean-all: uninstall-vim-plugins uninstall-brewfile uninstall-homebrew clean
