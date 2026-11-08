if status is-interactive

  function _prompt_nix_shell --on-event pre_hook_fish_prompt_build
    if set -q IN_NIX_SHELL
      set -g _fish_prompt_buffer "$_fish_prompt_buffer"(set_color blue)"❆ [$IN_NIX_SHELL] "(set_color normal)
    end
  end

end
