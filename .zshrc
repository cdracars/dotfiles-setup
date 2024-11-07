if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="${HOME}/.oh-my-zsh"

POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git golang zsh-autosuggestions docker history-substring-search kubectl gh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh

# bind home & end key
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Locale switching
alias zh_locale='
export LC_ALL=zh_TW.UTF-8
export LANG=zh_TW.UTF-8
export LANGUAGE=zh_TW.UTF-8
export LC_MESSAGE=zh_TW.UTF-8
export LC_TIME=zh_TW.UTF-8'

alias en_locale='
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_MESSAGE=en_US.UTF-8
export LC_TIME=en_US.UTF-8'

en_locale

export ZPLUG_HOME=~/.zplug

# tmux
export TMUX_PLUGIN_MANAGER_PATH=${HOME}/.tmux/plugins/tpm/

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# podman
if command -v podman &> /dev/null; then source <(podman completion zsh); fi

# npm
export PATH="${HOME}/.npm-global/bin":"${PATH}"

# kubernetes
if command -v kubectl &> /dev/null;
then
  export KUBECONFIG=$HOME/.kube/config
  source <(kubectl completion zsh)
  alias k=kubectl
fi

# rust
[ -f ${HOME}/.cargo/env ] && source ${HOME}/.cargo/env
if command -v bat &> /dev/null; then alias cat=bat; fi
if command -v eza &> /dev/null; then alias ls="eza --icons"; fi

# leetgo
export LEETCODE_SESSION=
export LEETCODE_CSRFTOKEN=

# gcloud
[ -f /usr/share/google-cloud-sdk/completion.zsh.inc ] && source /usr/share/google-cloud-sdk/completion.zsh.inc

# terraform
autoload -U +X bashcompinit && bashcompinit
if command -v terraform &> /dev/null; then complete -o nospace -C $(which terraform) terraform; fi

# argocd
if command -v argocd &> /dev/null; then source <(argocd completion zsh) compdef _argocd argocd; fi

# helm
if command -v helm &> /dev/null; then source <(helm completion zsh) ; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export SSH_AUTH_SOCK=~/.1password/agent.sock

# python
export PATH="${HOME}/.local":"${PATH}"

export EDITOR=vi

export PATH=/home/cfsdev/.local/bin:$PATH

# findread function for searching and displaying files with exclusions
findread() {
    # Load default exclusions from the .findreadconfig file, if it exists
    if [[ -f "$HOME/.findreadconfig" ]]; then
        source "$HOME/.findreadconfig"
    fi

    # Detect the shell to use the appropriate array-splitting method
    local shell_is_zsh=false
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_is_zsh=true
    fi

    # Split the space-separated strings into arrays for directories and files
    local exclude_dirs=()
    local exclude_files=()

    if $shell_is_zsh; then
        # In zsh, use ${=VAR} to split by whitespace
        exclude_dirs=(${=FINDREAD_EXCLUDE_DIRS})
        exclude_files=(${=FINDREAD_EXCLUDE_FILES})
    else
        # In bash, use IFS and read to split by whitespace
        IFS=' ' read -r -a exclude_dirs <<< "$FINDREAD_EXCLUDE_DIRS"
        IFS=' ' read -r -a exclude_files <<< "$FINDREAD_EXCLUDE_FILES"
    fi

    local debug=false  # Debug mode flag

    # Display help information
    if [[ "$1" == "--help" ]]; then
        echo "findread - A function to search and display file contents with exclusion options"
        echo
        echo "This function uses a configuration file (.findreadconfig) to manage default"
        echo "exclusions for directories and file patterns. You can create a .findreadconfig"
        echo "file in the project root directory with the following format:"
        echo
        echo "  FINDREAD_EXCLUDE_DIRS=\"./files ./node_modules ./.next ./.git ./dist ./.yarn\""
        echo "  FINDREAD_EXCLUDE_FILES=\"*.lock *.json *.md *.log *.svg *.ico\""
        echo
        echo "If the .findreadconfig file is not present, the function will use internal defaults."
        echo
        echo "Options:"
        echo "  --exclude-dir <directory>   Exclude additional directories from the search."
        echo "  --exclude-file <pattern>    Exclude additional file types from the search."
        echo "  --debug                     Show the built command without executing it."
        echo "  --help                      Show this help message and exit."
        echo
        echo "Examples:"
        echo "  findread                    Run with default exclusions from config file or internal defaults."
        echo "  findread --exclude-dir './public'   Exclude './public' directory in addition to defaults."
        echo "  findread --exclude-file '*.txt'     Exclude '.txt' files in addition to defaults."
        echo "  findread --debug             Show the command without executing it."
        return 0
    fi

    # Parse command line arguments for additional exclusions and debug mode
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --exclude-dir)
                if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                    exclude_dirs+=("$2")
                    shift 2
                else
                    echo "Error: --exclude-dir requires a directory argument."
                    return 1
                fi
                ;;
            --exclude-file)
                if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                    exclude_files+=("$2")
                    shift 2
                else
                    echo "Error: --exclude-file requires a pattern argument."
                    return 1
                fi
                ;;
            --debug)
                debug=true
                shift
                ;;
            *)
                echo "Unknown option: $1. Use --help for usage information."
                return 1
                ;;
        esac
    done

    # Build the find command dynamically
    local find_command="find ."

    # Add directory exclusions with -prune
    for dir in "${exclude_dirs[@]}"; do
        find_command+=" -path '$dir' -prune -o"
    done

    # Continue file search after pruning directories
    find_command+=" -type f"

    # Add file exclusions using ! -name for each pattern
    for file in "${exclude_files[@]}"; do
        find_command+=" ! -name '$file'"
    done

    find_command+=" -exec sh -c 'echo \"{}\"; cat \"{}\"; echo' \\;"

    # Output the command if debug mode is enabled
    if [[ "$debug" == true ]]; then
        echo "Built find command:"
        echo "$find_command"
        return 0
    fi

    # Execute the built find command
    eval "$find_command"
}

export GITHUB_TOKEN="op://Private/Package Modify PAT/token"
export PATH=$PATH:/home/cfsdev/.nvm/versions/node/v18.19.0/bin

