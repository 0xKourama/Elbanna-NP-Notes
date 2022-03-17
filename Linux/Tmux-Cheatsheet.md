# Increase copy mode buffer size
`echo 'set-option -g history-limit 10000' > ~/.tmux.conf`
# Enable tmux history
`echo 'set -g history-file ~/.tmux_history' >> ~/.tmux.conf`
# Set tmux to attach to a different directory
1. press `Ctrl + b + :`
2. type `attach -c desired/directory/path`