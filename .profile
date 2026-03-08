#!/usr/bin/env sh

# :::::::::::::::::::::::::
# POSIX compliant shell setup.

# add user's private and local bin paths.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# add golang bin paths.
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# add bun bin path.
export PATH="$PATH:$HOME/.bun/bin"

# configure nix.
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . $HOME/.nix-profile/etc/profile.d/nix.sh

# configure cargo.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# set default terminal.
command -v alacritty > /dev/null && export TERM=alacritty

# set default editor.
command -v nvim > /dev/null && export EDITOR=nvim

# set default shell.
command -v fish > /dev/null && export SHELL="$(which fish)"

# :::::::::::::::::::::::::
# start a new login shell.

exec -l "$SHELL"
