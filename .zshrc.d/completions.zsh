# podman
if command -v podman &> /dev/null; then source <(podman completion zsh); fi

# kubernetes
if command -v kubectl &> /dev/null;
then
  export KUBECONFIG=$HOME/.kube/config
  source <(kubectl completion zsh)
  alias k=kubectl
fi

# gcloud
[ -f /usr/share/google-cloud-sdk/completion.zsh.inc ] && source /usr/share/google-cloud-sdk/completion.zsh.inc

# terraform
autoload -U +X bashcompinit && bashcompinit
if command -v terraform &> /dev/null; then complete -o nospace -C $(which terraform) terraform; fi

# argocd
if command -v argocd &> /dev/null; then source <(argocd completion zsh) compdef _argocd argocd; fi

# helm
if command -v helm &> /dev/null; then source <(helm completion zsh) ; fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
