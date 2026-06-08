# HermitShell
*[GitHub Homepage](https://github.com/mmorys/hermitshell)*

<p align="center">
  <img src="./logo.png" alt="Logo" width="200">
</p>

A lightweight, single-repo shell configuration designed for **offline deployment**. This setup provides a unified experience across **Zsh**, **Bash**, and **Windows Git Bash** , featuring a two-line Powerlevel10k-style prompt without the overhead of heavy frameworks. It also provides some convenient plugins and familiar aliases. There is no need for a separate dotfile manager to get started.

<img width="1185" height="426" alt="zsh prompt" src="https://github.com/user-attachments/assets/1d72bdf0-b7ba-4b54-ac61-31ca94d67226" />

## ⚡ Quickstart

Install and configure **zsh** and **bash**:

```bash
git clone --depth=1 https://github.com/mmorys/hermitshell.git ~/.hermitshell
echo 'source ~/.hermitshell/hs_zshrc' >> ~/.zshrc
echo 'source ~/.hermitshell/hs_bashrc' >> ~/.bashrc
```

> ⚠️ **Warning:** Review your existing `.bashrc` and `.zshrc` for overlapping settings that may conflict. Pay special attention to UI configurations like **Powerlevel10k**, **Starship**, or other prompt frameworks, as these will clash with HermitShell's built-in prompt.

## ✨ Key Features

* **Offline Ready:** All plugins are **vendored** (source code included). No `git clone` calls happen during shell startup.
* **Dual-Shell Support:** Primary configuration for Zsh with a robust fallback for Bash.
* **Modular Design:** Pick and choose components (hs_env, hs_aliases_*, hs_*_hist, hs_*_ui) or use the full config.
* **Lightweight Prompt:** 2-line, bold, asynchronous Git status indicators using native `vcs_info`.
* **Smart Tooling:** Enhanced integration for `fzf`, `fd`, and `eza`/`exa` with automatic fallbacks.

## 📦 Included Plugins

This setup comes pre-loaded with the following vendored plugins to provide a "batteries-included" experience without needing an internet connection:

* **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**: Provides Fish-like "type-ahead" predictions based on your command history.
* **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)**: Adds real-time color feedback to the command line, highlighting valid commands and syntax errors.
* **[fzf-tab](https://github.com/Aloxaf/fzf-tab)**: Replaces the standard Zsh completion menu with a powerful, searchable `fzf` interface.
* **[dirhistory](https://github.com/mmorys/dirhistory)**: Allows for fast directory navigation using `Alt` + `Arrow Keys` (Left/Right for back/forward, Up for parent).
* **[zsh-z](https://github.com/agkozak/zsh-z)**: Highly optimized directory jumper using zsh-native functions, similar to `autojump` or `j`.

## 📁 Directory Structure

*Assuming a standard installation cloned to ~/.hermitshell*

```text
~/.hermitshell/
├── hs_zshrc             # Main Zsh entry point
├── hs_bashrc            # Main Bash entry point
├── hs_env               # Environment variables
├── hs_aliases_ls        # ls/exa aliases
├── hs_aliases_git       # Git aliases and functions
├── hs_zsh_hist          # Zsh history settings
├── hs_bash_hist         # Bash history settings
├── hs_zsh_ui            # Zsh UI (fzf, prompt, completions, plugins)
├── hs_bash_ui           # Bash UI (fzf, prompt)
└── zsh/
    ├── update-plugins.sh   # Atomic plugin update script
    ├── functions/          # Custom completion scripts (e.g., _docker)
    └── plugins/            # Vendored plugin source code
```

## 📥 Installation

### 1. Clone the Repository

Clone this repo to your home directory:

```bash
git clone --depth=1 https://github.com/mmorys/hermitshell.git ~/.hermitshell
```

### 2. Source the Configuration

Add the following line to your shell configuration file:

### Zsh

Add to `~/.zshrc`:

```bash
source ~/.hermitshell/hs_zshrc
```

### Bash

Add to `~/.bashrc`:

```bash
source ~/.hermitshell/hs_bashrc
```

### Alternative: Pick and Choose

You can source individual components instead of the full config:

```bash
# Example: Only environment and Git aliases
source ~/.hermitshell/hs_env
source ~/.hermitshell/hs_aliases_git
```

## 🔄 Updating

To update HermitShell to the latest version:

```bash
cd ~/.hermitshell
git pull
```

## 🛠 Maintenance

### Updating Plugins

> **Note:** These instructions are meant to be carried out by the developer of the plugin, but included here in case there is a user need to perform this locally.

Since this repo vendors plugin source code to remain offline-compatible, you cannot use standard plugin managers. Instead, use the provided update script. It performs "atomic" updates by cloning to a temporary directory and stripping Git metadata before moving files into place.

```bash
# Run the update script
bash ~/.hermitshell/zsh/update-plugins.sh

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

## 🎨 Prompt Customization

The prompt is configured to mimic the "Lean" Powerlevel10k style:

* **Path:** Bold Blue (Color 39: `#00afff`).
* **Git Branch:** Bold Green.
* **Dirty State:** Yellow `*` (unstaged) or `+` (staged).
* **Character:** Bold Green `❯`.

To change colors, modify the `PROMPT` variable in `hs_zsh_ui` or the `PS1` variable in `hs_bash_ui`.

## ⚖️ License

The configuration files and scripts in the root of this repository are licensed under the **MIT License**.

The vendored plugins located in `zsh/plugins/` are the property of their respective authors and are licensed under their original licenses (MIT and BSD 3-Clause). Original license files are preserved within each plugin's directory.
