# environment defaults
# export TERM=alacritty # only if alacritty exists on the machine
export EDITOR=nvim

# include user's private bin
PATH="$HOME/bin:$PATH"
# include user's private local bin
PATH="$HOME/.local/bin:$PATH"

# Cargo 
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# start fish as the interactive shell if it exists
if [ -x "$(command -v fish)" ]; then
  exec -l fish
fi

