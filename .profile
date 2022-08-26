# environment defaults
export TERM=alacritty
export EDITOR=nvim

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private local bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Cargo PATH
if [ -d "$HOME/.cargo/bin" ] ; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# start fish as the interactive shell if it exists
if [ -x "$(command -v fish)" ] ; then
  exec -l fish
fi

