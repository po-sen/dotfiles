SHELL := /bin/bash
FILES :=

BREW ?= /opt/homebrew/bin/brew
NVIM ?= /opt/homebrew/bin/nvim
ASDF ?= /opt/homebrew/bin/asdf
BASH ?= /opt/homebrew/bin/bash

NEWSHELL ?= $(BASH)


FILES += $(HOME)/.vim/autoload/plug.vim $(HOME)/.config/nvim/autoload/plug.vim
$(HOME)/.vim/autoload/plug.vim $(HOME)/.config/nvim/autoload/plug.vim:
	@curl --silent --create-dirs -fLo $@ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

FILES += $(HOME)/.vimrc $(HOME)/.config/nvim/init.vim
$(HOME)/.vimrc $(HOME)/.config/nvim/init.vim: $(PWD)/vimrc
	@ln -sf $(PWD)/vimrc $@

FILES += $(HOME)/.bash_profile
$(HOME)/.bash_profile: $(PWD)/bash_profile
	@ln -sf $(PWD)/bash_profile $@

FILES += $(HOME)/.gitconfig
$(HOME)/.gitconfig: $(PWD)/gitconfig
	@ln -sf $(PWD)/gitconfig $@

FILES += $(HOME)/.tool-versions
$(HOME)/.tool-versions: $(PWD)/tool-versions
	@ln -sf $(PWD)/tool-versions $@

.PHONY: clean
clean:
	@rm -rf $(FILES)

.PHONY: install-homebrew
install-homebrew: $(FILES)
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: uninstall-homebrew
uninstall-homebrew:
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	@sudo rm -rf /opt/homebrew/

.PHONY: install-brewfile
install-brewfile: $(FILES) $(BREW)
	$(BREW) update
	$(BREW) bundle install --force --cleanup
	$(BREW) list --versions

.PHONY: update-brewfile
update-brewfile: $(FILES) $(BREW)
	$(BREW) update
	$(BREW) bundle install --force
	$(BREW) bundle dump --force --brews --casks --taps
	$(BREW) list --versions

.PHONY: uninstall-brewfile
uninstall-brewfile: $(BREW)
	@set -euo pipefail; \
	BREW_LIST=$$($(BREW) bundle list --all); \
	if [[ -n "$$BREW_LIST" ]]; then \
		$(BREW) uninstall --force --ignore-dependencies $$BREW_LIST; \
	fi;

.PHONY: install-vim-plugins
install-vim-plugins: $(FILES) $(NVIM)
	$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall 2> /dev/null

.PHONY: uninstall-vim-plugins
uninstall-vim-plugins:
	@rm -rf $(HOME)/.vim/plugged/*

.PHONY: install-tool-versions
install-tool-versions: $(FILES) $(ASDF) $(PWD)/tool-versions
	@cut -d' ' -f1 $(PWD)/tool-versions|xargs -I{} $(ASDF) plugin add {}
	$(ASDF) install

.PHONY: uninstall-tool-versions
uninstall-tool-versions: $(FILES) $(ASDF) $(PWD)/tool-versions
	@cut -d' ' -f1 $(PWD)/tool-versions|xargs -I{} $(ASDF) plugin remove {}

.DEFAULT_GOAL := pull-remote
.PHONY: pull-remote
pull-remote:
	@git config remote.origin.url git@github.com:po-sen/dotfiles.git
	@git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
	@git fetch --force origin
	@git reset --hard origin/$(shell git branch --show-current)

.PHONY: change-shell
change-shell: $(FILES) $(NEWSHELL)
	@grep -Fxq "$(NEWSHELL)" /etc/shells || echo "$(NEWSHELL)" | sudo tee -a /etc/shells
	chsh -s $(NEWSHELL)

.PHONY: install
install: install-homebrew install-brewfile install-vim-plugins install-tool-versions

.PHONY: update
update: update-brewfile install-vim-plugins install-tool-versions

.PHONY: uninstall
uninstall: uninstall-tool-versions uninstall-vim-plugins uninstall-brewfile uninstall-homebrew clean
