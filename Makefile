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
	cd brew && "$(homebrew)/brew" bundle
	@echo

	#
	# 👆 Enabling sudo via TouchID
	#
	grep -qs pam_tid.so /etc/pam.d/sudo_local || \
		echo 'auth       sufficient     pam_tid.so' | sudo tee /etc/pam.d/sudo_local

	#
	# 🐟 Making fish the default shell and configuring it
	#
	grep -qx "$(homebrew)/fish" /etc/shells || echo "$(homebrew)/fish" | sudo tee -a /etc/shells
	dscl . -read "$(HOME)" UserShell | grep -q "$(homebrew)/fish" || chsh -s "$(homebrew)/fish"
	mkdir -p "$(HOME)/.config/fish/conf.d"
	ln -sf "$(location)/fish/config.fish" "$(HOME)/.config/fish/config.fish"
	ln -sf $(location)/fish/conf.d/*.fish $(HOME)/.config/fish/conf.d/
	test -e "$(HOME)/.config/fish/conf.d/secrets.fish" || cp "$(location)/fish/secrets.example.fish" "$(HOME)/.config/fish/conf.d/secrets.fish"
	test -e "$(HOME)/.config/fish/conf.d/local.fish" || cp "$(location)/fish/local.example.fish" "$(HOME)/.config/fish/conf.d/local.fish"
	ln -sf "$(location)/fish/fish_plugins" "$(HOME)/.config/fish/fish_plugins"
	fish -c "fisher update"
	@echo

	#
	# 🚀 Configuring starship
	#
	mkdir -p "$(HOME)/.config"
	ln -sf "$(location)/starship/starship.toml" "$(HOME)/.config/starship.toml"
	@echo

	#
	# 📝 Configuring vim
	#
	ln -sf "$(location)/vim/.vimrc" "$(HOME)/.vimrc"
	@echo

	#
	# 🧰 Configuring mise
	#
	mkdir -p "$(HOME)/.config/mise"
	ln -sf "$(location)/mise/config.toml" "$(HOME)/.config/mise/config.toml"
	"$(homebrew)/mise" install
	@echo

	#
	# ♻️ Configuring git
	#
	ln -sf "$(location)/git/.gitignore_global" "$(HOME)/.gitignore_global"
	mkdir -p "$(HOME)/.config/git"
	ln -sf "$(location)/git/.gitconfig" "$(HOME)/.config/git/config"
	# ~/.gitconfig is per-machine (and where `git config --global` writes), so replace any old symlink to the shared config
	! test -L "$(HOME)/.gitconfig" || rm "$(HOME)/.gitconfig"
	test -e "$(HOME)/.gitconfig" || cp "$(location)/git/local.example.gitconfig" "$(HOME)/.gitconfig"
	@echo

	#
	# 👻 Configuring ghostty
	#
	mkdir -p "$(HOME)/Library/Application Support/com.mitchellh.ghostty"
	ln -sf "$(location)/ghostty/config.ghostty" "$(HOME)/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
	@echo

	#
	# 🤖 Configuring Claude Code
	#
	mkdir -p "$(HOME)/.claude"
	ln -sf "$(location)/claude/settings.json" "$(HOME)/.claude/settings.json"
	ln -sf "$(location)/claude/statusline-command.sh" "$(HOME)/.claude/statusline-command.sh"
	ln -sf "$(location)/claude/notify.sh" "$(HOME)/.claude/notify.sh"
	ln -sf "$(location)/claude/focus-ghostty.sh" "$(HOME)/.claude/focus-ghostty.sh"
	ln -sfn "$(location)/claude/icons" "$(HOME)/.claude/notify-icons"
	@echo

	#
	# 🍎 MacOS System Config
	#
	osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
	sudo pmset hibernatemode 25
	# Keyboard: fast key repeat with a short initial delay
	defaults write -g InitialKeyRepeat -int 15
	defaults write -g KeyRepeat -int 2
	# Mouse: enable secondary (right) click
	defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string TwoButton
	defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton
	# Trackpad: disable "natural" scrolling, two-finger click/tap for secondary click
	defaults write -g com.apple.swipescrolldirection -bool false
	defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	# Dock: left, auto-hide, scale effect, minimise into app icon, no recents or folder stacks
	defaults write com.apple.dock orientation -string left
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock mineffect -string scale
	defaults write com.apple.dock minimize-to-application -bool true
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock persistent-others -array
	defaults write com.apple.dock showhidden -bool true
	defaults write com.apple.dock appswitcher-all-displays -bool true
	killall Dock
	@echo "ℹ️  Keyboard, mouse and trackpad changes take effect after logging out and back in"

