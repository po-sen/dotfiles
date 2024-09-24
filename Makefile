SHELL := /bin/bash
FILES :=

GIT ?= /usr/bin/git
CURL ?= /usr/bin/curl
SUDO ?= /usr/bin/sudo
BREW ?= /opt/homebrew/bin/brew
BASH ?= /opt/homebrew/bin/bash
NVIM ?= /opt/homebrew/bin/nvim
ASDF ?= /opt/homebrew/bin/asdf

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

FILES += $(HOME)/.tool-versions
$(HOME)/.tool-versions:
	@ln -sf $(PWD)/tool-versions $(HOME)/.tool-versions

.PHONY: install-homebrew
install-homebrew: $(FILES) $(CURL)
	@bash -c "$$($(CURL) -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: uninstall-homebrew
uninstall-homebrew: $(CURL) $(SUDO)
	@bash -c "$$($(CURL) -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	@$(SUDO) rm -rf /opt/homebrew/

.PHONY: install-brewfile
install-brewfile: $(FILES) $(BREW)
	$(BREW) update
	$(BREW) bundle install --force
	$(BREW) list --versions

.PHONY: update-brewfile
update-brewfile: $(FILES) $(BREW)
	$(BREW) update
	$(BREW) bundle install --force
	$(BREW) bundle dump --force --brews --casks --tap
	$(BREW) list --versions

.PHONY: uninstall-brewfile
uninstall-brewfile:
	@set -euo pipefail; \
	BREW_LIST=$$($(BREW) bundle list --all); \
	if [[ -n "$$BREW_LIST" ]]; then \
		$(BREW) uninstall --force --ignore-dependencies $$BREW_LIST; \
	fi;

.PHONY: install-vim-plugins
install-vim-plugins: $(FILES) $(NVIM)
	$(NVIM) --headless +PlugUpgrade +PlugInstall +qall 2> /dev/null

.PHONY: update-vim-plugins
update-vim-plugins: $(FILES) $(NVIM)
	$(NVIM) --headless +PlugUpgrade +PlugUpdate +qall 2> /dev/null

.PHONY: uninstall-vim-plugins
uninstall-vim-plugins:
	@rm -rf $(HOME)/.vim/plugged/*

.PHONY: install-tool-versions
install-tool-versions: $(FILES) $(ASDF)
	$(ASDF) plugin add python
	$(ASDF) plugin add nodejs
	$(ASDF) install

.PHONY: uninstall-tool-versions
uninstall-tool-versions: $(FILES) $(ASDF)
	$(ASDF) plugin remove python
	$(ASDF) plugin remove nodejs

.DEFAULT_GOAL := pull-remote
.PHONY: pull-remote
pull-remote: $(GIT)
	@$(GIT) config remote.origin.url git@github.com:po-sen/dotfiles.git
	@$(GIT) config remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
	@$(GIT) fetch --force origin
	@$(GIT) reset --hard origin/$(shell git branch --show-current)

.PHONY: install
install: install-homebrew install-brewfile install-vim-plugins install-tool-versions

.PHONY: update
update: update-brewfile update-vim-plugins install-tool-versions

.PHONY: clean
clean: uninstall-tool-versions uninstall-vim-plugins uninstall-brewfile uninstall-homebrew
	@rm -rf $(FILES)

.PHONY: change-shell
change-shell: $(FILES) $(BASH) $(SUDO)
	grep -Fxq "$(BASH)" /etc/shells || echo "$(BASH)" | $(SUDO) tee -a /etc/shells
	chsh -s $(BASH)

.PHONY: revert-shell
revert-shell:
	chsh -s /bin/zsh
