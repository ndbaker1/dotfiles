
setopt histignorealldups sharehistory

# Set vi bindings
bindkey -v

# Update PATH
PATH=$HOME/.cargo/bin:$PATH

# Variables
CONFIG_DIR="$HOME/.config"
EDITOR="nvim"

## Aliases
# Replace ls with exa
if [ -n "$(command -v exa)" ]; then
	alias l='exa'
	alias ls='exa -a'
	alias ll='exa --long --header --git -a'
fi
# Use Neovim
if [ -n "$(command -v nvim)" ]; then
	alias vi='nvim'
	alias vim='nvim'
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

# Enable Auto Completion
#extension_dir="$HOME/.config/zsh/zsh-autocomplete" 
#[ -d "$extension_dir" ] || git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git  $extension_dir
#source $extension_dir/zsh-autocomplete.plugin.zsh

# Enable FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

