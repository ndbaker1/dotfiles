# environment

if command -v alacritty > /dev/null; then
  export TERM=alacritty
fi

if command -v nvim > /dev/null; then
  export EDITOR=nvim
fi

# include user's private bin and local bin
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# golang path
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# cargo 
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if command -v fish > /dev/null; then
  export SHELL="$(which fish)"
  exec -l fish
fi
