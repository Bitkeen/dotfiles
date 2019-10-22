#!/bin/sh
# Reload .Xresources.
alias xup='xrdb ~/.Xresources'
# Reload .bashrc.
alias bup='source ~/.bashrc'
# Reload .tmux.conf.
alias tup='tmux source-file ~/.tmux.conf'
# Reload Readline's .inputrc.
alias rup='bind -f ~/.inputrc'

alias ls='ls -p'
alias ll='ls -AlF'

# Prompt before overwriting.
alias mv='mv -i'

# Highlight matches, ignore case distinctions.
alias grep='grep --color=auto --ignore-case'
# Output line numbers with -n.
# Ignore binary files with -I.
alias gr='grep -n -I'

# Find.
alias fn='find . -name'
# Case-insensitive.
alias fin='find . -iname'

# Git.
alias g='git'
alias l='lab'

# Kill processes by name.
alias ka='killall'

alias d='docker'
alias c='docker-compose'

# Open ranger.
# The ranger-cd version switches the directory in bash on exit,
# r.shell allows to expand shell aliases inside the :shell command.
alias r='SHELL=~/.local/bin/system/ranger-shell.sh ranger-cd'

alias t='tmux'
alias ta='tmux attach -t'

# Open (with) vim.
alias v='vim'
alias vm='vman '
alias vs='vim -S'

# The space at the end allows the next command word following the alias
# to also be checked for alias expansion.
alias s='sudo '

# Create directory.
# -p - no error if existing, make parent directories as needed.
# -v - print a message for each created directory.
alias mkd='mkdir -pv'

alias tch='touch'

alias nb='newsboat'

alias py='python'
alias ipy='ipython'
# Python virtualenvwrapper.
alias wo='workon'
alias deac='deactivate'

alias bandcamp-dl='bandcamp-dl --base-dir=$HOME/Downloads/bandcamp-dl'

alias yd='youtube-dl'
# Download playlists using a separate config.
# The config specifies different directory structure.
alias ydp='youtube-dl --config-location ~/.config/youtube-dl-playlist.conf'
# There are options to download subtitles in the main config file,
# the subtitles are not needed for audio-only downloads, and can't
# be merged into an audio file, so a separate config file for audio
# is needed, without the subtitle options.
alias yda='youtube-dl --config-location ~/.config/youtube-dl-audio.conf'

# --auto-vertical-output - automatically switch to vertical output
# mode if the result is wider than the terminal width.
alias mycli='mycli --auto-vertical-output'

alias dpl='dotfiles_pull'
alias dps='dotfiles_push'

alias nb='newsboat'
