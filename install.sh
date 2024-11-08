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

# Ensure Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions plugin if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# Install powerlevel10k theme if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k"
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

echo "Dotfiles setup complete."
