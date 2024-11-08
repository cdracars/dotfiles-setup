export ZSH="${HOME}/.oh-my-zsh"
plugins=(git golang zsh-autosuggestions docker history-substring-search kubectl gh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh
