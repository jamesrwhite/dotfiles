# 👨🏻‍💻 Dotfiles

My slow attempt to formalise all the tweaks I end up making to each machine
I set up. Very much a work in progress.

## Setup

### Clone Repo

```bash
cd && git clone git@github.com:jamesrwhite/dotfiles.git .dotfiles
```

The above will clone it in `$HOME/.dotfiles`

### Run Setup

```bash
make setup
```

This assumes the repo was cloned to `$HOME/.dotfiles`, if it wasn't you can pass
the `location=/path/to/dotfiles` argument.

### Mac Settings

> TODO: look into automating these via https://macos-defaults.com/#💻-list-of-commands

- [x] enable dark mode
- [x] full hibernate on laptop close
- [ ] Reduce keyboard repeat key lag
- [ ] move doc to left
- [ ] hide applications holder in dock
- [ ] right click on mouse
- [ ] invert scroll on trackpad
- [ ] double tap to right click on trackpad
- [ ] turn dock hiding on
- [ ] minimise to dock using scale
- [ ] minimise windows into app window
- [ ] don't show recent apps in dock

### VS Code

- Setting Sync

### TODO

- Add shell to `/etc/shells`
- link `.vimrc`
- Add `.config/starship.toml`
