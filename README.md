# 👨🏻‍💻 Dotfiles

My slow attempt to formalise all the tweaks I end up making to each machine
I set up. Very much a work in progress.

## What's Configured

### Homebrew (`brew/Brewfile`)

- Casks: browsers, chat/email/news apps, media, developer tools (VS Code, Ghostty, SourceTree), fonts (Nerd Fonts, Hasklig, Fira), utilities (1Password, Rectangle, Raycast)
- Brews: unix tools (`bat`, `lsd`, `fzf`, `zoxide`, `coreutils`), dev/k8s tooling (`mise`, `docker`, `colima`, `kubectl`, `k9s`, `helm`, `awscli`, `gcloud-cli`), shell (`fish`, `starship`), git (`diff-so-fancy`), network/monitoring (`nmap`, `ipinfo-cli`, `htop`, `btop`), and AI tools (`claude-code`, `codex`, `skills`)

### Shell — fish (`fish/config.fish`, `fish/conf.d/*.fish`, `fish/fish_plugins`)

- `config.fish`: VS Code shell integration, `mise` activation, `zoxide` init, key bindings, emoji width fix
- `conf.d/aliases.fish`: aliases (`ls`→`lsd`, `cat`→`bat`, etc.) and abbreviations for git, k8s, docker, pnpm
- `conf.d/env.fish`: sets `$EDITOR` to vim
- `conf.d/functions.fish`: helper functions — `mkcd`, `b64`/`b64d`, `ql`, `dotenv`, `cld` (open Claude desktop on a folder)
- `conf.d/path.fish`: PATH setup for personal scripts, Homebrew, Go, pipx, cargo
- `fish_plugins`: managed via `fisher` — `bass`, async prompt, fzf/zoxide, humanize-duration

### mise (`mise/config.toml`)

- Global tool versions: `node` (LTS), `tflint`, `usage`

### Git (`git/.gitconfig`, `git/.gitignore_global`)

- User identity + SSH-based commit signing
- Extensive aliases: `lg` (graph log), `rbm` (rebase on main), `com` (checkout main), `cf` (fixup commit), `sp` (stash pop), etc.
- Sensible defaults: autostash/autosquash rebases, fast-forward-only pull/merge, `zdiff3` conflict style, prune on fetch
- Global ignore patterns for macOS, Node, Python, Ruby, VS Code

### Ghostty (`ghostty/config.ghostty`)

- JetBrainsMono Nerd Font, Vercel theme, custom padding
- Fish shell integration, working-directory inheritance rules for splits/tabs

### Claude Code (`claude/settings.json`, `claude/statusline-command.sh`)

- Auto mode enabled, `sonnet` model, medium effort level, custom statusline script
- Permission allowlist: incident.io MCP tools

### Vim (`vim/.vimrc`)

- Syntax highlighting, line numbers, sane backspace behaviour

### macOS defaults (applied via `Makefile`)

- Dark mode, sudo via Touch ID, hibernate mode 25
- Fast key repeat, two-button mouse, non-natural scrolling, two-finger secondary click on trackpad
- Dock on the left, auto-hidden, scale minimise effect, minimise into app icon, no recent apps or folder stacks
- Keyboard, mouse and trackpad changes need a log out to take effect

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

### VS Code

- Setting Sync

### TODO

- Add shell to `/etc/shells`
- link `.vimrc`
- Add `.config/starship.toml`
