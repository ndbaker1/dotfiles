if status is-interactive

  # use zoxide if it exists
  if command -v zoxide &> /dev/null 
    zoxide init fish | source
    abbr -a cd z
  end

  # use starship if it exists
  if command -v starship &> /dev/null 
    starship init fish | source
  end

  # extra vim bindings
  fish_vi_key_bindings

  # nice abbreviations
  abbr -a g 'git'

  if command -v tmux &> /dev/null
    abbr -a t 'tmux'
  end
  if command -v cargo &> /dev/null
    abbr -a c 'cargo'
  end
  if command -v nvim &> /dev/null
    abbr -a vi 'nvim'
    abbr -a vim 'nvim'
  end

  # use exa over ls with nice shortcuts
  if command -v exa &> /dev/null
    abbr -a l 'exa'
    abbr -a ls 'exa -lg'
    abbr -a ll 'exa -lag'
    abbr -a lll 'exa -lag --tree'
  else
    abbr -a l 'ls'
    abbr -a ls 'ls -l'
    abbr -a ll 'ls -la'
  end

  # use ripgrep if exists
  if command -v rg &> /dev/null
    abbr -a ghist 'history | rg'
  else
    abbr -a ghist 'history | grep'
  end

end
