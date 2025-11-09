#!/bin/bash
# install.sh

set -e  # Exit immediately if any command fails

echo "Setting up dotfiles..."

# Detect OS
OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
    echo "macOS detected"
    source ./mac/setup.sh
elif [[ "$OS" == "Linux" ]]; then
    echo "Linux detected"
    source ./linux/setup.sh
else
    echo "Unsupported OS"
    exit 1
fi

# Function to create symlinks with backup
link_dotfile() {
    local src="$PWD/$1"
    local dest="$HOME/$1"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "Backing up existing $dest"
        mv "$dest" "$dest.backup"
    elif [[ -L "$dest" ]]; then
        rm "$dest"  # Remove old symlink
    fi
    ln -sf "$src" "$dest"
    echo "Linked $src to $dest"
}

get_current_shell() {
    if command -v getent >/dev/null 2>&1; then
        getent passwd "$USER" | cut -d: -f7
    elif [[ "$OS" == "Darwin" ]] && command -v dscl >/dev/null 2>&1; then
        dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}'
    else
        echo "${SHELL:-}"
    fi
}

ensure_default_shell_is_zsh() {
    local zsh_path
    zsh_path="$(command -v zsh || true)"
    if [[ -z "$zsh_path" ]]; then
        echo "zsh is not installed; skipping default shell change."
        return
    fi

    local current_shell
    current_shell="$(get_current_shell)"

    if [[ "$current_shell" == "$zsh_path" ]]; then
        echo "Default shell already set to $zsh_path"
        return
    fi

    echo "Setting default shell to $zsh_path (current: ${current_shell:-unknown})"
    if chsh -s "$zsh_path"; then
        echo "Default shell updated. You may need to log out and back in for it to take effect."
    else
        echo "Failed to set default shell automatically. Run 'chsh -s $zsh_path' manually."
    fi
}

launch_zsh_if_interactive() {
    if [[ -t 0 && -t 1 ]] && command -v zsh >/dev/null 2>&1; then
        echo "Starting a new zsh session..."
        exec zsh -l
    fi
}

# Ensure Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Ensure custom directory reference resolves to $HOME
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM_DIR/plugins" "$ZSH_CUSTOM_DIR/themes"

# Install zsh-autosuggestions plugin if not installed
if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
fi

# Install powerlevel10k theme if not installed
if [ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
fi

# Link each primary dotfile
link_dotfile ".zshrc"
link_dotfile ".gitconfig"

# Link the .zshrc.d directory
if [[ -d "$PWD/.zshrc.d" ]]; then
    mkdir -p "$HOME/.zshrc.d"  # Ensure destination directory exists
    for file in "$PWD/.zshrc.d/"*; do
        filename=$(basename "$file")
        link_dotfile ".zshrc.d/$filename"
    done
fi

ensure_default_shell_is_zsh

echo "Dotfiles setup complete."

launch_zsh_if_interactive
