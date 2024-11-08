#!/bin/bash
# install.sh

set -e  # Exit if any command fails

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

# Function to create symlinks
link_dotfile() {
    local src="$PWD/$1"
    local dest="$HOME/$1"
    if [[ -e "$dest" ]]; then
        echo "Backing up $dest"
        mv "$dest" "$dest.backup"
    fi
    ln -sf "$src" "$dest"
    echo "Linked $src to $dest"
}

# Link each dotfile
link_dotfile ".zshrc"
link_dotfile ".aliases"
link_dotfile ".functions"
link_dotfile ".gitconfig"

echo "Dotfiles setup complete."

