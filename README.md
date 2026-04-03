# HermitShell

<p align="center">
  <img src="./logo.png" alt="Logo" width="200">
</p>

A lightweight, single-repo shell configuration designed for **offline deployment**. This setup provides a unified experience across **Zsh** and **Bash**, featuring a two-line Powerlevel10k-style prompt in ZSH without the overhead of heavy frameworks. There is no need for a separate dotfile manager to get started.

## ✨ Key Features
* **Offline Ready:** All plugins are **vendored** (source code included). No `git clone` calls happen during shell startup.
* **Dual-Shell Support:** Primary configuration for Zsh with a robust fallback for Bash.
* **Modular Design:** * `.commonrc`: Shared aliases and functions.
    * `.privaterc`: Local secrets and machine-specific tweaks (not tracked by Git).
* **Lightweight Prompt:** 2-line, bold, asynchronous Git status indicators using native `vcs_info`.
* **Smart Tooling:** Enhanced integration for `fzf`, `fd`, and `eza`/`exa` with automatic fallbacks.

## 📦 Included Plugins

This setup comes pre-loaded with the following vendored plugins to provide a "batteries-included" experience without needing an internet connection:

* **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**: Provides Fish-like "type-ahead" predictions based on your command history.
* **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)**: Adds real-time color feedback to the command line, highlighting valid commands and syntax errors.
* **[fzf-tab](https://github.com/Aloxaf/fzf-tab)**: Replaces the standard Zsh completion menu with a powerful, searchable `fzf` interface.
* **[dirhistory](https://github.com/mmorys/dirhistory)**: Allows for fast directory navigation using `Alt` + `Arrow Keys` (Left/Right for back/forward, Up for parent).

---

## 📁 Directory Structure

*Assuming a standard installation cloned to ~/.dotfiles*

```text
~/.dotfiles/
├── .commonrc               # Shared aliases/functions for Bash & Zsh
├── .bashrc                 # Main Bash configuration
├── .zshrc                  # Main Zsh configuration
├── zsh/
│   ├── update-plugins.sh   # Atomic plugin update script
│   ├── functions/          # Custom completion scripts (e.g., _docker)
│   └── plugins/            # Vendored plugin source code
```

---

## 📥 Installation

Deploying to a new (even offline) machine is a simple three-step process.

### 1. Clone the Repository
Clone this repo to your home directory:
```bash
git clone https://github.com/mmorys/hermitshell.git ~/.dotfiles
```

### 2. Create Symlinks
Link the configurations to your home directory. **Note:** Back up any existing `.zshrc` or `.bashrc` first.
```bash
# Link the main shell configs
ln -s ~/.dotfiles/.commonrc ~/.commonrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.bashrc ~/.bashrc

# Ensure the shell finds the common config
# (Note: .zshrc and .bashrc look for .commonrc inside ~/.dotfiles/ by default)
```

### 3. Setup Private Config (Optional)
Create a `.privaterc` in your home directory for any environment variables or aliases you don't want to track in Git:
```bash
touch ~/.privaterc
```

---

## 🛠 Maintenance

### Updating Plugins
Since this repo vendors plugin source code to remain offline-compatible, you cannot use standard plugin managers. Instead, use the provided update script. It performs "atomic" updates by cloning to a temporary directory and stripping Git metadata before moving files into place.

```bash
# Run the update script
bash ~/.dotfiles/zsh/update-plugins.sh

# Commit the changes to your repo
git add zsh/plugins/
git commit -m "chore: update vendored plugins"
```

### Adding New Tools
This setup is optimized for:
* **`eza`** (or `exa`): For icons and directory-first sorting.
* **`fzf`**: Version 0.29+ (includes specific system-path scanning logic).
* **`fd`**: Used to supercharge `fzf` search speeds.

If these tools are missing, the shell will gracefully fall back to standard `ls` and `find`.

---

## 🎨 Prompt Customization
The prompt is configured to mimic the "Lean" Powerlevel10k style:
* **Path:** Bold Blue (Color 39: `#00afff`).
* **Git Branch:** Bold Green.
* **Dirty State:** Yellow `*` (unstaged) or `+` (staged).
* **Character:** Bold Green `❯`.

To change colors, modify the `PROMPT` variable in `.zshrc` or the `PS1` variable in `.bashrc`.

## ⚖️ License

The configuration files and scripts in the root of this repository are licensed under the **MIT License**.

The vendored plugins located in `zsh/plugins/` are the property of their respective authors and are licensed under their original licenses (MIT and BSD 3-Clause). Original license files are preserved within each plugin's directory.