# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k first so its instant prompt runs before anything else
if [[ -f "$HOME/.zshrc.d/p10k.zsh" ]]; then
  source "$HOME/.zshrc.d/p10k.zsh"
fi

# Source the remaining configuration files
for config_file in "$HOME"/.zshrc.d/*.zsh; do
  [[ "$config_file" == "$HOME/.zshrc.d/p10k.zsh" ]] && continue
  source "$config_file"
done

# bind home & end key
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

export GITHUB_TOKEN="op://Private/Package Modify PAT/token"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
