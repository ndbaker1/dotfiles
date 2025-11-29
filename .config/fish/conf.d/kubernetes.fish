if status is-interactive

  # ::::::::::::::::::
  # prefer workspace-scoped kubeconfig

  export KUBECONFIG="$KUBECONFIG:.kube/config:$HOME/.kube/config"

  # ::::::::::::::::::
  # setup kubernetes tooling abbreviations

  if command -v kubectl &> /dev/null
    abbr -a k 'kubectl'
  end

end
