SHELL := /bin/sh

ifeq ($(shell /usr/bin/uname -m), arm64)
HOMEBREW_PREFIX ?= /opt/homebrew
else
HOMEBREW_PREFIX ?= /usr/local
endif

BREW ?= $(HOMEBREW_PREFIX)/bin/brew
NVIM ?= $(HOMEBREW_PREFIX)/bin/nvim
ASDF ?= $(HOMEBREW_PREFIX)/bin/asdf

NEWSHELL ?= $(HOMEBREW_PREFIX)/bin/bash


$(HOME)/.vim/autoload/plug.vim $(HOME)/.config/nvim/autoload/plug.vim:
	@curl --silent --create-dirs -fLo $@ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(HOME)/.vimrc $(HOME)/.config/nvim/init.vim: $(PWD)/vimrc
	@ln -sf $^ $@


.DEFAULT_GOAL := pull-remote
.PHONY: pull-remote
pull-remote:
	@git config remote.origin.url git@github.com:po-sen/dotfiles.git
	@git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
	@git fetch --force origin
	@git reset --hard origin/$(shell git branch --show-current)

.PHONY: init
init: $(PWD)/config/*
	@$(foreach FILE, $^, ln -sf $(FILE) $(HOME)/.$(notdir $(FILE));)

.PHONY: clean
clean: $(PWD)/config/*
	@$(foreach FILE, $^, rm -f $(HOME)/.$(notdir $(FILE));)

.PHONY: install-homebrew
install-homebrew:
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: uninstall-homebrew
uninstall-homebrew:
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

.PHONY: install-brewfile
install-brewfile:
	$(BREW) update
	$(BREW) bundle install --force --cleanup
	@chmod -R go-w "$(shell brew --prefix)/share"

.PHONY: update-brewfile
update-brewfile:
	$(BREW) update
	$(BREW) bundle install --force
	$(BREW) bundle dump --force --brews --casks --taps --vscode
	$(BREW) upgrade
	$(BREW) cleanup
	@chmod -R go-w "$(shell brew --prefix)/share"

.PHONY: uninstall-brewfile
uninstall-brewfile:
	@set -euo pipefail; \
	BREW_LIST=$$($(BREW) bundle list --all); \
	if [[ -n "$$BREW_LIST" ]]; then \
		$(BREW) uninstall --force --ignore-dependencies $$BREW_LIST; \
	fi;

.PHONY: install-vim-plugins
install-vim-plugins: $(HOME)/.vimrc $(HOME)/.config/nvim/init.vim $(HOME)/.vim/autoload/plug.vim $(HOME)/.config/nvim/autoload/plug.vim
	$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall 2> /dev/null

.PHONY: uninstall-vim-plugins
uninstall-vim-plugins:
	@rm -rf $(HOME)/.vimrc $(HOME)/.vim/ $(HOME)/.config/nvim/*

.PHONY: install-tool-versions
install-tool-versions: $(HOME)/.tool-versions
	@cut -d' ' -f1 $(HOME)/.tool-versions | xargs -rI{} $(ASDF) plugin add {}
	@cut -d' ' -f1 $(HOME)/.tool-versions | xargs -rI{} $(ASDF) plugin update {}
	@cut -d' ' -f1 $(HOME)/.tool-versions | xargs -rI{} $(ASDF) install {}

.PHONY: uninstall-tool-versions
uninstall-tool-versions: $(HOME)/.tool-versions
	@$(ASDF) plugin list | grep -v '^*$$' | xargs -rI{} $(ASDF) plugin remove {}

.PHONY: newshell
newshell:
	@ls $(NEWSHELL)
	@grep -Fxq "$(NEWSHELL)" /etc/shells || echo "$(NEWSHELL)" | sudo tee -a /etc/shells
	chsh -s $(NEWSHELL)

.PHONY: install
install: install-homebrew install-brewfile install-vim-plugins install-tool-versions

.PHONY: update
update: update-brewfile install-vim-plugins install-tool-versions

.PHONY: uninstall
uninstall: uninstall-tool-versions uninstall-vim-plugins uninstall-brewfile uninstall-homebrew
