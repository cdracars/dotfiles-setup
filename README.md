# Dotfiles Setup

This repository contains a script to set up your dotfiles and related configurations. The script supports both macOS and Linux.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/dotfiles-setup.git
    cd dotfiles-setup
    ```

2. Make the `install.sh` script executable:
    ```bash
    chmod +x install.sh
    ```

3. Run the `install.sh` script:
    ```bash
    ./install.sh
    ```

## What the Script Does

- Detects the operating system (macOS or Linux) and sources the appropriate setup script.
- Creates symlinks for the specified dotfiles, backing up any existing files.
- Ensures Oh My Zsh is installed.
- Installs the `zsh-autosuggestions` plugin if not already installed.
- Installs the `powerlevel10k` theme if not already installed.
- Links primary dotfiles such as `.zshrc` and `.gitconfig`.
- Links all files in the `.zshrc.d` directory.

## Adding New Dotfiles

To add new dotfiles to the setup script:
1. Place the new dotfile in the repository directory.
2. Add a call to `link_dotfile` in the `install.sh` script for the new dotfile.

Example:
