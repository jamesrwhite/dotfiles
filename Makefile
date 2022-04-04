SHELL := /bin/bash
homebrew = $(shell test -d /opt/homebrew/bin && echo -n '/opt/homebrew/bin' || echo -n '/usr/local/bin')
location := $(HOME)/.dotfiles

setup:
	#
	# 🍺 Install brew
	#
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh -o brew.sh
	chmod +x brew.sh
	./brew.sh
	rm brew.sh
	@echo

	#
	# 🏗 Installing apps and tools via brew
	#
	cd brew && "$(homebrew)/brew" bundle --no-lock
	@echo

	#
	# 🐟 Making fish the default shell and configuring it
	#
	chsh -s "$(homebrew)/fish"
	ln -sf "$(location)/fish/config.fish" "$(HOME)/.config/fish/config.fish"
	ln -sf "$(location)/fish/fish_plugins" "$(HOME)/.config/fish/fish_plugins"
	curl -L https://iterm2.com/shell_integration/fish -o "$(HOME)/.iterm2_shell_integration.fish"
	fish -c "fisher update"
	@echo

	#
	# ♻️ Configuring git
	#
	ln -sf "$(location)/git/.gitignore_global" "$(HOME)/.gitignore_global"
	ln -sf "$(location)/git/.gitconfig" "$(HOME)/.gitconfig"
