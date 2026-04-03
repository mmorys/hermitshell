### -------------- Source common -------------------
[ -f "$HOME/.commonrc" ] && source "$HOME/.commonrc"

### -------------- History -------------------
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

### -------------- Exports -------------------
# Prepend custom functions and fzf-tab to fpath
fpath=(~/.local/share/zsh/functions ~/.dotfiles/zsh/functions ~/.dotfiles/zsh/plugins/fzf-tab $fpath)

### -------------- fzf setup -------------------
if command -v fzf >/dev/null 2>&1; then
    # Search for and source system-installed fzf integration scripts
    [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    
    if [[ "$(uname -s)" == "Darwin" && "$(command -v brew)" != "" ]] ; then
        local FZF_HOME=$(brew --prefix)/opt/fzf
        [ -f $FZF_HOME/shell/completion.zsh ] && source $FZF_HOME/shell/completion.zsh
        [ -f $FZF_HOME/shell/key-bindings.zsh ] && source $FZF_HOME/shell/key-bindings.zsh
    fi

    if [ -n "${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
    fi

    # fzf / fd integrations
    if command -v fd &> /dev/null; then
        _fzf_compgen_path() {
            echo "$1"
            fd --type d --type f --type l --hidden --exclude .git --exclude .hg --exclude .svn --base-directory "$1" . 2> /dev/null
        }
        _fzf_compgen_dir() {
            fd --type d --hidden --exclude .git --exclude .hg --exclude .svn --base-directory "$1" . 2> /dev/null
        }
        
        export FZF_CTRL_T_COMMAND="fd --hidden --exclude .git --exclude .hg --exclude .svn --exclude sysfs --exclude devfs --exclude devtmpfs --exclude proc --type f --type d --type l --strip-cwd-prefix"
        export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git --exclude .hg --exclude .svn --exclude sysfs --exclude devfs --exclude devtmpfs --exclude proc --strip-cwd-prefix"
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
    fi
fi

### -------------- Custom Prompt ----------
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zsh_git_counts() {
    # Check if we are in a git repo
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Get the status porcelain output once to save performance
        local status_output=$(git status --porcelain 2>/dev/null)
        
        # Count staged files (Changes to be committed - first column)
        local staged_count=$(echo "$status_output" | grep -c '^[MADRC]')
        # Count unstaged files (Changes not staged for commit - second column)
        local unstaged_count=$(echo "$status_output" | grep -c '^.[MD]')
        # Count untracked files
        local untracked_count=$(echo "$status_output" | grep -c '??')

        GIT_COUNTS=""
        # Staged (+) - Green
        [[ $staged_count -gt 0 ]] && GIT_COUNTS+="%F{green} +$staged_count%f"
        # Unstaged (!) - Yellow
        [[ $unstaged_count -gt 0 ]] && GIT_COUNTS+="%F{yellow} !$unstaged_count%f"
        # Untracked (?) - Red/Blue (Red used here for visibility)
        [[ $untracked_count -gt 0 ]] && GIT_COUNTS+="%F{red} ?$untracked_count%f"
    else
        GIT_COUNTS=""
    fi
}

# Register hooks
add-zsh-hook precmd vcs_info
add-zsh-hook precmd zsh_git_counts

# Format vcs_info for branch name
zstyle ':vcs_info:git:*' formats ' %F{green}%b%f'

# Build the prompt
setopt PROMPT_SUBST
PROMPT=$'%B%F{39}%~%f%b%B${vcs_info_msg_0_}${GIT_COUNTS}%b\n%B%F{green}❯%f%b '

### -------------- Completions -------------------
# Load and initialize the completion system
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

### -------------- Vendored Plugins -------------------
# Path to the plugins folder we created
ZDOT_PLUGINS="$HOME/.dotfiles/zsh/plugins"

# Source plugins directly from the local file system
[ -f "$ZDOT_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZDOT_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$ZDOT_PLUGINS/fzf-tab/fzf-tab.plugin.zsh" ] && source "$ZDOT_PLUGINS/fzf-tab/fzf-tab.plugin.zsh"
[ -f "$ZDOT_PLUGINS/dirhistory/dirhistory.plugin.zsh" ] && source "$ZDOT_PLUGINS/dirhistory/dirhistory.plugin.zsh"
# syntax-highlighting must be sourced last
[ -f "$ZDOT_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZDOT_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

