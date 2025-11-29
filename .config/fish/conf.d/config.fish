if status is-interactive

  # ::::::::::::::::::
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

  # ::::::::::::::::::
  # prefer eza over ls, and add abbreviations for both
  # see: https://github.com/eza-community/eza

  if command -v eza &> /dev/null
    abbr -a ls 'eza -lg'
    abbr -a ll 'eza -lag'
    abbr -a lll 'eza -lag --tree'
  else
    abbr -a ls 'ls -l'
    abbr -a ll 'ls -la'
    abbr -a lll 'ls -laR'
  end

  # ::::::::::::::::::
  # setup yazi, a really great terminal file manager
  # see: https://github.com/sxyazi/yazi

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

  # ::::::::::::::::::
  # setup fzf shortcuts

  if command -v fzf &> /dev/null
    bind -M insert \cR 'commandline -r (history | fzf --height 40% --select-1)'
  end

  # ::::::::::::::::::
  # amend the fish prompt

  functions --copy fish_prompt fish_prompt_original

  function fish_prompt
    if test $SHLVL -gt 1
      set_color blue; echo -n "($SHLVL) "; set_color normal;
    end

    fish_prompt_original
  end

end
