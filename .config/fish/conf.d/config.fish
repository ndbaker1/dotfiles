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
    abbr -a tm 'tmux a || tmux'
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
    fzf --fish | source
  end

  # ::::::::::::::::::
  # setup fish prompt hooks

  functions --copy fish_prompt fish_prompt_original

  function fish_prompt
    set -g _fish_prompt_buffer ""
    emit pre_hook_fish_prompt_build
    echo -n $_fish_prompt_buffer
    fish_prompt_original
    set -g _fish_prompt_buffer ""
    emit post_hook_fish_prompt_build
    echo -n $_fish_prompt_buffer
  end

  function _prompt_shell_level --on-event pre_hook_fish_prompt_build
    if test $SHLVL -gt 1
      set -g _fish_prompt_buffer "$_fish_prompt_buffer"(set_color blue)"($SHLVL) "(set_color normal)
    end
  end

end
