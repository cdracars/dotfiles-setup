# rust
[ -f ${HOME}/.cargo/env ] && source ${HOME}/.cargo/env
if command -v bat &> /dev/null; then alias cat=bat; fi
if command -v eza &> /dev/null; then alias ls="eza --icons"; fi
