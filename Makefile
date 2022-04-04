location := "~/.dotfiles"

setup:
	#
	# 🍺 Install brew
	#
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh -o brew.sh
	chmod +x brew.sh
	./brew.sh
	rm brew.sh
	brew doctor
	@echo

	#
	# 🏗 Installing apps and tools via brew
	#
	cd brew && brew bundle
	@echo

	#
	# 🐟 Making fish the default shell and configuring it
	#
	chsh -s /usr/local/bin/fish
	ln -s "~/$(location)/fish/config.fish" "~/.config/fish/config.fish"
	fisher add jethrokuan/z
	fisher add franciscolourenco/done
	@echo

	#
	# ♻️ Configuring git
	#
	ln -sf "~/$(location)/git/.gitignore_global" "~/.gitignore_global"
	ln -sf "~/$(location)/git/.gitconfig" "~/.gitconfig"
