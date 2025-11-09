export ZSH="${HOME}/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
plugins=(git golang zsh-autosuggestions docker history-substring-search kubectl gh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh
