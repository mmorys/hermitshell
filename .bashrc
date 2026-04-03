### -------------- Source common -------------------
[ -f "$HOME/.commonrc" ] && source "$HOME/.commonrc"

### -------------- History -------------------
export HISTFILE=~/.bash_history
export HISTSIZE=50000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

### -------------- Exports -------------------


### -------------- fzf setup -------------------
if command -v fzf >/dev/null 2>&1; then
    # Search for and source system-installed fzf integration scripts
    [ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/doc/fzf/examples/completion.bash ] && source /usr/share/doc/fzf/examples/completion.bash
    [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    
    if [[ "$(uname -s)" == "Darwin" && "$(command -v brew)" != "" ]] ; then
        local FZF_HOME=$(brew --prefix)/opt/fzf
        [ -f $FZF_HOME/shell/completion.bash ] && source $FZF_HOME/shell/completion.bash
        [ -f $FZF_HOME/shell/key-bindings.bash ] && source $FZF_HOME/shell/key-bindings.bash
    fi

    if command -v fzf-share &> /dev/null; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
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
# Fast function to extract the current Git branch (Matches Zsh formatting)
__parse_git_branch() {
    local branch
    branch=$(git branch --show-current 2> /dev/null)
    if [ -n "$branch" ]; then
        # \033[1;32m is Bold Green, \033[0m is Reset
        echo -e " \033[1;32m${branch}\033[0m"
    fi
}

# Define color variables for the prompt
# Note: \[ and \] are required in Bash to prevent line-wrapping issues
C_BLUE='\[\e[34m\]'
C_GREEN='\[\e[32m\]'
C_RESET='\[\e[00m\]'

# Build the prompt
PS1="${C_BLUE}\w${C_RESET}\$(__parse_git_branch)\n${C_GREEN}❯${C_RESET} "
