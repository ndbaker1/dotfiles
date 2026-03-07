if status is-interactive

  # ::::::::::::::::::
  # prefer workspace-scoped kubeconfig

  export KUBECONFIG="$KUBECONFIG:.kube/config:$HOME/.kube/config"

  # ::::::::::::::::::
  # setup kubernetes tooling abbreviations

  if command -v kubectl &> /dev/null
    abbr -a k 'kubectl'
    
    # TODO: i like this but i need to stardardize fish prompts better.
    function fish_prompt
        fish_prompt_original
        if kubectl config current-context &> /dev/null
            set_color FFBBBA
            printf "%s" "(☁︎  $(kubectl config current-context))> "
            set_color normal
        end
    end

    if command -v kubecolor &> /dev/null
      alias kubectl='kubecolor'
    end
  end

end
