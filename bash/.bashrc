# Main {{{

export EDITOR=/usr/bin/vim
# Don't limit the number of commands to save in history.
export HISTSIZE=-1
# Don't save lines matching a previous history entry.
export HISTCONTROL=ignoredups:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Even though vi-mode is already set through readline configuration,
# still need to set it here for fzf default bindings to work.
set -o vi

# Enable autocd for bash versions greater than 4.
[ "${BASH_VERSINFO[0]}" -ge 4 ] && shopt -s autocd

# Source fzf-related files.
fzf_bindings_file="/usr/share/fzf/key-bindings.bash"
if [ -f "$fzf_bindings_file" ]; then
    source "$fzf_bindings_file"
fi
fzf_completion_file="/usr/share/fzf/completion.bash"
if [ -f "$fzf_completion_file" ]; then
    source "$fzf_completion_file"
fi

# Avoid loading default config file for ranger if a custom one exists.
ranger_config_file="$HOME/.config/ranger/rc.conf"
if [ -f "$ranger_config_file" ]; then
    export RANGER_LOAD_DEFAULT_RC=FALSE
fi

# Enable completion for git.
git_completion_file="/usr/share/bash-completion/completions/git"
if [ -f "$git_completion_file" ]; then
    source $git_completion_file

    # Make git completion work with an alias if it exists.
    git_alias=$(alias | awk '/git/ {print $2}' | cut -f 1 -d '=')
    if [ -n "$git_alias" ]; then
        complete -o default -o nospace -F _git $git_alias
    fi
fi

# Where user-specific Python packages are installed.
export PATH=$PATH:$HOME/.local/bin

export PATH="$PATH:$HOME/.vim/bundle/vim-superman/bin"

# Base16 Shell.
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Enable completion for pip.
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

# }}}

# Prompt {{{

bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

arrow_color="\[$(tput setaf 208)\]"
ranger_color="\[$(tput setaf 96)\]"
vim_color="\[$(tput setaf 70)\]"
venv_color="\[$(tput setaf 66)\]"
ssh_color="\[$(tput setaf 239)\]"
git_color="\[$(tput setaf 75)\]"

# Working directory.
ps1_left="${reset}${bold}\w${reset}"
ps1_right=""

function ps1_vim {
    if [ -n "$VIMRUNTIME" ]; then
        vim_status="in vim"
    else
        vim_status=""
    fi
    [ -n "$vim_status" ] && echo " ($vim_status)"
}

# Modify the prompt when using a shell from inside ranger.
function ps1_ranger {
    if [ -n "$RANGER_LEVEL" ]; then
        ranger="in ranger"
    else
        ranger=""
    fi
    [ -n "$ranger" ] && echo " ($ranger)"
}

# Modify the prompt when using a virtual environment.
function ps1_venv {
    if [ -n "$VIRTUAL_ENV" ]; then
        # Strip out the path and just leave the env name.
        venv="${VIRTUAL_ENV##*/}"
    else
        venv=""
    fi
    [ -n "$venv" ] && echo " ($venv)"
}

# Disable the default virtualenv prompt change.
export VIRTUAL_ENV_DISABLE_PROMPT=1

ps1_right+="${reset}${bold}${vim_color}\$(ps1_vim)${reset}"
ps1_right+="${reset}${bold}${ranger_color}\$(ps1_ranger)${reset}"
ps1_right+="${reset}${bold}${venv_color}\$(ps1_venv)${reset}"

# git-prompt.sh provides __git_ps1 that is used to show current Git branch
# in bash prompt.
git_prompt_file='/usr/share/git/completion/git-prompt.sh'
if [ -f "$git_prompt_file" ]; then
    # Add a '$' in the __git_ps1 output to show stashed changes
    # are present.
    export GIT_PS1_SHOWSTASHSTATE=1
    # Show unstaged (*) and staged (+) changes next to the branch name.
    export GIT_PS1_SHOWDIRTYSTATE=1

    source "$git_prompt_file"
    ps1_right+="${reset}${bold}${git_color}\$(__git_ps1)${reset}"
fi

# Modify the prompt when using SSH.
if [ -n "$SSH_CLIENT" ]; then
    ps1_u_at_h="${reset}${bold}\u@\h " # user@host
    ps1_left="${ps1_u_at_h}${ps1_left}"
    ps1_right+=" ${reset}${bold}${ssh_color}(ssh)${reset}"
fi

# Show the number of background jobs in the number is greater than 0.
ps1_jobs='$([ \j -gt 0 ] && echo " [\j]")'
ps1_right+="${reset}${bold}${ps1_jobs}${reset}"

# Add an arrow at the end.
# Last space is actually an nbsp. It is used for searching the
# previous command in tmux (see .tmux.conf).
ps1_arrow=' > '
ps1_right+="${reset}${bold}${arrow_color}${ps1_arrow}${reset}"

export PS1="${ps1_left}${ps1_right}"

# }}}

# Aliases and functions {{{

# Add main bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Add  functions.
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

# Add local (untracked) bash aliases.
if [ -f ~/.bash_aliases.local ]; then
    source ~/.bash_aliases.local
fi

# Add docker aliases.
if [ -f ~/.docker_aliases ]; then
    source ~/.docker_aliases
fi

# Add lab aliases.
if [ -f ~/.lab_aliases ]; then
    source ~/.lab_aliases
fi

# }}}
