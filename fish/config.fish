#
# PATH
#

# Configure GOPATH and add binaries to the PATH
set GOPATH /Users/james/go
set PATH $GOPATH/bin $PATH

# Add homebrew's sbin to the PATH
set PATH "/usr/local/sbin" $PATH

# Add the Google Cloud SDK to the PATH
test -e $HOME/google-cloud-sdk/path.fish.inc && source $HOME/google-cloud-sdk/path.fish.inc

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

#
# Other
#

# iTerm Fish Integration
test -e $HOME/.iterm2_shell_integration.fish && source $HOME/.iterm2_shell_integration.fish

# Theme config
fish_default_key_bindings

# Load asdf version manager
source (brew --prefix asdf)/asdf.fish
