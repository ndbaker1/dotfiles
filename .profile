#!/usr/bin/env sh

# :::::::::::::::::::::::::
# POSIX compliant shell setup.

# set default terminal.
if command -v alacritty > /dev/null; then
  export TERM=alacritty
fi

# set default editor.
if command -v nvim > /dev/null; then
  export EDITOR=nvim
fi

# add user's private and local bin paths.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# configure golang.
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# configure cargo.
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# set default shell.
if command -v fish > /dev/null; then
  export SHELL="$(which fish)"
fi

# :::::::::::::::::::::::::
# start a new login shell.

exec -l "$SHELL"
