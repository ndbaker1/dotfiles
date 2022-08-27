if status is-interactive

  starship init fish | source

  fish_vi_key_bindings

  abbr -a t tmux
  abbr -a c cargo
  abbr -a vi nvim
  abbr -a vim nvim
  abbr -a g git

  if command -v exa &> /dev/null
    abbr -a l 'exa'
    abbr -a ls 'exa -lg'
    abbr -a ll 'exa -lag'
  else
    abbr -a l 'ls'
    abbr -a ll 'ls -l'
    abbr -a lll 'ls -la'
  end

  if command -v git &> /dev/null
    abbr -a gs 'git status'
  end

  # make some custom mappings to windows executables if we are in a WSL instance
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null
    for cmd in cargo rustup rustc rg
      alias $cmd=$cmd.exe
    end
  end
end
