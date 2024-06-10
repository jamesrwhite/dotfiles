# Add homebrew to the PATH
set PATH "/opt/homebrew/bin" $PATH
set PATH "/opt/homebrew/sbin" $PATH
set PATH "/usr/local/sbin" $PATH

# Configure GOPATH and add binaries to the PATH
set -x GOPATH ~/go
set PATH $GOPATH/bin $PATH

# For pipx
set PATH $PATH $HOME/.local/bin

# For cargo
set PATH $PATH $HOME/.cargo/bin

