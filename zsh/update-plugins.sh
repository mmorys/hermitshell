#!/bin/bash

# Update all vendored zsh plugins to their latest versions
set -e

# Ensure we're using the right directory relative to the script
DOTFILES_ZSH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$DOTFILES_ZSH_DIR/plugins"

# Create directory if it doesn't exist
mkdir -p "$PLUGINS_DIR"

# Plugin definitions
declare -A PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
    ["dirhistory"]="https://github.com/mmorys/dirhistory.git"
)

# Color helper using printf for maximum compatibility
info() { printf "\nUpdating: \033[1;34m%s\033[0m\n" "$1"; }
success() { printf "  Status: \033[0;32mComplete\033[0m\n"; }
error() { printf "  Status: \033[0;31mFailed: %s\033[0m\n" "$1"; }

echo "Updating zsh plugins..."
echo "========================"

for plugin_name in "${!PLUGINS[@]}"; do
    repo_url="${PLUGINS[$plugin_name]}"
    plugin_path="$PLUGINS_DIR/$plugin_name"
    
    info "$plugin_name"
    
    # 1. Clone to a temporary location first for safety
    TEMP_DIR=$(mktemp -d)
    
    # 2. Shallow clone (depth 1) is much faster
    if git clone --depth 1 "$repo_url" "$TEMP_DIR" &> /dev/null; then
        # 3. Swap the old for the new
        rm -rf "$plugin_path"
        mv "$TEMP_DIR" "$plugin_path"
        
        # 4. Remove .git metadata
        rm -rf "$plugin_path/.git"
        success
    else
        error "Could not clone repository"
        rm -rf "$TEMP_DIR"
    fi
done

echo -e "\n========================"
echo "Update process finished!"
echo "Run: git add zsh/plugins/ && git commit -m 'chore: update plugins'"