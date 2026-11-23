# Add homebrew to the PATH
set PATH "/opt/homebrew/bin" $PATH
set PATH "/opt/homebrew/sbin" $PATH
set PATH "/usr/local/sbin" $PATH

# Bun
fish_add_path "/Users/james/.bun/bin"

# Google Cloud
set PATH "/opt/homebrew/share/google-cloud-sdk/bin" $PATH

# Configure GOPATH and add binaries to the PATH
set -x GOPATH ~/go
set PATH $GOPATH/bin $PATH

# For pipx
set PATH $PATH $HOME/.local/bin
