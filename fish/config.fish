# iTerm Fish Integration
test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

# Theme config
fish_default_key_bindings

# Load mise version manager (shims, not activate, so per-directory tool
# versions resolve correctly in non-interactive contexts too, e.g. Makefiles)
fish_add_path -g $HOME/.local/share/mise/shims

# Setup zoxide (z)
zoxide init fish | source

# Fix emoji rendering
set -g fish_emoji_width 4

# Remove welcome message
set -g fish_greeting

# VS Code integration
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)

# Trust the Obsidian Local REST API's self-signed cert for Node/Claude Code MCP
set -gx NODE_EXTRA_CA_CERTS $HOME/.obsidian-mcp/obsidian-local-rest-api.crt
