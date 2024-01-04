# iTerm Fish Integration
test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

# Theme config
fish_default_key_bindings

# Load mise version manager
/opt/homebrew/bin/mise activate fish | source

# Fix emoji rendering
set -g fish_emoji_width 4

# Remove welcome message
set -g fish_greeting

# VS Code integration
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
