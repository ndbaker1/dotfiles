if status is-interactive

  # ::::::::::::::::::
  # prefer workspace-scoped kubeconfig

  export KUBECONFIG="$KUBECONFIG:.kube/config:$HOME/.kube/config"

  export K9S_CONFIG_DIR="$HOME/.config/k9s"

  # ::::::::::::::::::
  # setup kubernetes tooling abbreviations

  if command -v kubectl &> /dev/null
    abbr -a k 'kubectl'

    function _prompt_kube --on-event pre_hook_fish_prompt_build
      if kubectl config current-context &> /dev/null
        set -g _fish_prompt_buffer "$_fish_prompt_buffer"(set_color FFBBBA)"($(kubectl config current-context))> "(set_color normal)
      end
    end

    if command -v kubecolor &> /dev/null
      alias kubectl='kubecolor'
    end
  end

end
