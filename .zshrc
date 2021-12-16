# enter tmux
if [ -n "$(command -v tmux)" ]; then
  [ "$TMUX" = "" ] && ( tmux a || tmux )
else
  return
fi

# Load prompt
[ -n "$(command -v neofetch)" ] && neofetch || echo "neofetch not installed."

setopt histignorealldups sharehistory

# Set vi bindings
bindkey -v
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey '^H' backward-kill-word

# Update PATH
PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH

# Variables
CONFIG_DIR="$HOME/.config"
EDITOR="nvim"

## Aliases
# Replace ls with exa
if [ -n "$(command -v exa)" ]; then
	alias l='exa --group-directories-first'
	alias ls='l -a --icons'
	alias ll='ls --long --header --git'
else
	echo "exa is not installed."
fi
# Use Neovim
if [ -n "$(command -v nvim)" ]; then
	alias vi='nvim'
	alias vim='nvim'
else
	echo "neovim is not installed."
fi

# Various curl utilities
alias weather='curl wttr.in'
alias parrot='curl parrot.live'

# Starship Prompt
eval "$(starship init zsh)"

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

extension_dir="$HOME/.config/zsh/zsh-syntax-highlighting" 
# Enable Syntax Highlighting
[ -d "$extension_dir" ] || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $extension_dir
source $extension_dir/zsh-syntax-highlighting.zsh

# Enable Auto Suggestions
extension_dir="$HOME/.config/zsh/zsh-autosuggestions" 
[ -d "$extension_dir" ] || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $extension_dir
source $extension_dir/zsh-autosuggestions.zsh

# Enable FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

