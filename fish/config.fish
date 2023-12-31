#
# PATH
#

# Add homebrew to the PATH
set PATH "/opt/homebrew/bin" $PATH
set PATH "/opt/homebrew/sbin" $PATH
set PATH "/usr/local/sbin" $PATH

# Add the Google Cloud SDK to the PATH
test -e $HOME/google-cloud-sdk/path.fish.inc && source $HOME/google-cloud-sdk/path.fish.inc

# Configure GOPATH and add binaries to the PATH
set -x GOPATH (go env GOPATH)
set PATH $GOPATH/bin $PATH

# For pipx
set PATH $PATH $HOME/.local/bin

# For Check Sheet
set PATH $PATH "$HOME/Development/Check Sheet/code/bin"

#
# Prompt
#
eval (starship init fish)

#
# Aliases
#

alias json 'jq -C .'
alias page 'less -R'
alias k kubectl
alias kns kubens
alias kctx kubectx
alias mk minikube
alias tf terraform
alias g git
alias flushdns "sudo killall -HUP mDNSResponder"
alias copy pbcopy
alias dsusage ncdu
alias dc docker-compose
alias d docker
alias md macdown
alias cat bat
alias ping "prettyping --nolegend"
alias c code
alias m gmake
alias make gmake
alias l "lsd --icon never"
alias ls "lsd --icon never"
alias ll "lsd -alF --icon never"
abbr --add unset 'set --erase'

#
# Functions
#

function mkcd
    mkdir -p $argv && cd $argv
end

function b64d
    echo -n $argv | base64 --decode
end

function b64
    echo -n $argv | base64
end

function ql
    qlmanage -p $argv
end

#
# Other
#

# iTerm Fish Integration
test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

# Theme config
fish_default_key_bindings

# Load asdf version manager
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Fix emoji rendering
set -g fish_emoji_width 4

# Remove welcome message
set -g fish_greeting

