if status is-interactive

  # extra vim bindings
  fish_vi_key_bindings

  # ::::::::::::::::::

  # nice abbreviations

  if command -v git &> /dev/null
    abbr -a g 'git'
  end
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
  if command -v yazi &> /dev/null
    function yy
    	set tmp (mktemp -t "yazi-cwd.XXXXXX")
    	yazi $argv --cwd-file="$tmp"
    	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    		cd -- "$cwd"
    	end
    	rm -f -- "$tmp"
    end
  end

  # use eza over ls with nice shortcuts
  if command -v eza &> /dev/null
    abbr -a l 'eza'
    abbr -a ls 'eza -lg'
    abbr -a ll 'eza -lag'
    abbr -a lll 'eza -lag --tree'
  else
    abbr -a l 'ls'
    abbr -a ls 'ls -l'
    abbr -a ll 'ls -la'
  end

  # ::::::::::::::::::

  # setup/use binaries if they exist

  if command -v zoxide &> /dev/null 
    zoxide init fish --cmd cd | source
  end
  if command -v starship &> /dev/null 
    starship init fish | source
  end

end
