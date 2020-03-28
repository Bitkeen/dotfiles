#!/usr/bin/env sh
# Tmux dropdown launch script.
#
# Arguments:
# $1 - terminal window name
# $2 - tmux session to attach to

[ -z "$1" ] && exit 1
[ -z "$2" ] && exit 1

dd_name="$1"
session_name="$2"

launch_new_terminal() {
    # Tmux dropdown is not running.
    tmux_cmd="tmux new-session -A -s $session_name"
    i3 "exec --no-startup-id urxvt -name $dd_name -e $tmux_cmd"

    # Wait until the session is ready.
    while ! tmux ls | grep "$session_name" | grep attached
    do
        continue
    done
}

existing_dd="$(pgrep -fa "urxvt -name $dd_name")"
if [ -n "$existing_dd" ]; then
    # Tmux dropdown is already running.
    attached_session="$(echo "$existing_dd" | awk '{ print $NF }')"
    if [ "$attached_session" != "$session_name" ]; then
        # Attached session is different from the one passed in
        # arguments. Kill the terminal and launch a new one.
        existing_dd_pid="$(echo "$existing_dd" | awk '{ print $1 }')"
        kill "$existing_dd_pid"
        launch_new_terminal
    fi
else
    # Tmux dropdown is not running.
    launch_new_terminal
fi

# Show dropdown window.
i3 "[instance=\"$dd_name\"] scratchpad show; [instance=\"$dd_name\"] move position center"
