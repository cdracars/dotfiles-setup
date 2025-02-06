# rust
[ -f ${HOME}/.cargo/env ] && source ${HOME}/.cargo/env
if command -v bat &> /dev/null; then alias cat=bat; fi
if command -v eza &> /dev/null; then alias ls="eza --icons"; fi


# Code directory
alias js='cd ~/code/javascript'
alias ph='cd ~/code/php'
alias shell='cd ~/code/shell'
alias py='cd ~/code/python'

# Tree
alias xtree="tree -I 'node_modules|dist|coverage|*.{jpg,png,svg,log,lock}' -L 4 --dirsfirst | xclip -selection clipboard"  # Linux
