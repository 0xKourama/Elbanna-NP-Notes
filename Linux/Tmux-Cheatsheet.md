# Increase copy mode buffer size
`echo 'set-option -g history-limit 10000' > ~/.tmux.conf`

# Enable tmux history
`echo 'set -g history-file ~/.tmux_history' >> ~/.tmux.conf`

# Set tmux to attach to a different directory
1. press `Ctrl + b + :`
2. type `attach -c desired/directory/path`

# Tmux search
To search in the tmux history buffer for the current window, press Ctrl-b [ to enter copy mode.

If you're using emacs key bindings (the default), press Ctrl-s then type the string to search for and press Enter. Press n to search for the same string again. Press Shift-n for reverse search. Press Escape twice to exit copy mode. You can use Ctrl-r to search in the reverse direction. Note that since tmux is in control of the keyboard in copy mode, Ctrl-s works regardless of the stty ixon setting (which I like to have as stty -ixon to enable forward searches in Bash).

If you're using vi key bindings (Ctrl-b:set-window-option -g mode-keys vi), press / then type the string to search for and press Enter. Press n to search for the same string again. Press Shift-n for reverse search as in emacs mode. Press q twice to exit copy mode. You can use ? to search in the reverse direction.