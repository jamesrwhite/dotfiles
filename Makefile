SHELL := /bin/bash
homebrew = $(shell test -d /opt/homebrew/bin && echo -n '/opt/homebrew/bin' || echo -n '/usr/local/bin')
location := $(HOME)/.dotfiles

setup:
	#
	# 🍺 Install brew
	#
	which brew || (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh -o brew.sh && \
	chmod +x brew.sh && \
	./brew.sh && \
	rm brew.sh)
	@echo

	#
	# 🏗 Installing apps and tools via brew
	#
	cd brew && "$(homebrew)/brew" bundle --no-lock
	@echo

	#
	# 👆 Enabling sudo via TouchID
	#
	echo 'auth       sufficient     pam_tid.so' | sudo tee /etc/pam.d/sudo_local

	#
	# 🐟 Making fish the default shell and configuring it
	#
	chsh -s "$(homebrew)/fish"
	mkdir -p "$(HOME)/.config/fish"
	ln -sf "$(location)/fish/config.fish" "$(HOME)/.config/fish/config.fish"
	ln -sf $(location)/fish/conf.d/*.fish $(HOME)/.config/fish/conf.d/
	cp "$(location)/fish/secrets.example.fish" "$(HOME)/.config/fish/conf.d/secrets.fish"
	cp "$(location)/fish/local.example.fish" "$(HOME)/.config/fish/conf.d/local.fish"
	ln -sf "$(location)/fish/fish_plugins" "$(HOME)/.config/fish/fish_plugins"
	curl -L https://iterm2.com/shell_integration/fish -o "$(HOME)/.iterm2_shell_integration.fish"
	fish -c "fisher update"
	@echo

	#
	# ♻️ Configuring git
	#
	ln -sf "$(location)/git/.gitignore_global" "$(HOME)/.gitignore_global"
	ln -sf "$(location)/git/.gitconfig" "$(HOME)/.gitconfig"

	#
	# 🍎 MacOS System Config
	#
	osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
	defaults write com.apple.dock showhidden -bool TRUE
	killall Dock
	sudo pmset hibernatemode 25

