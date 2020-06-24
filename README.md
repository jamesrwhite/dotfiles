# 👨🏻‍💻 Dotfiles

My slow attempt to formalise all the tweaks I end up making to each machine
I set up. Very much a work in progress.

# Steps

> TODO: create a `Makefile` that carries out most of these steps

## Clone this repo

  $ git clone git@github.com:jamesrwhite/dotfiles.git

## Install brew

  $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

## Install dependencies

  $ cd dotfiles/brew && brew bundle

## Configure Shell

- add `/usr/local/bin/fish` to `/etc/shells`

  $ chsh -s /usr/local/bin/fish

## Link git and fish config

- `ln -s ~/.dotfiles/git/.gitignore_global .`
- `ln -s ~/.dotfiles/git/.gitconfig .`
- `ln -s ~/.dotfiles/fish/config.fish .config/fish/config.fish`

## Configure fish

- Install fisher:
  - `curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish`
  - `fisher add jethrokuan/z`
  - `fisher add franciscolourenco/done`
  - `fisher add bang-bang`

## Mac Settings

> TODO: look into automating these

- move doc to left
- hide applications holder in dock
- right click on mouse
- invert scroll on trackpad
- double tap to right click on trackpad
- turn dock hiding on
- system wide dark mode
- minimise to dock using scale
- minimise windows into app window
- dont show recent apps in dock

## VS Code

- Setting Sync
