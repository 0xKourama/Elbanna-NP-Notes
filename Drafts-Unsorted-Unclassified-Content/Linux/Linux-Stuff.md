# Finding distro type
```bash
cat /etc/issue
cat /etc/lsb-release      # Debian based
cat /etc/redhat-release   # Redhat based
```

# Find glibc version
`ldd --version`

# Tmux copy/paste
1. Enter Copy mode:
`Ctrl + b then [`
2. Select
`Ctrl + Space`
3. Copy
`Ctrl + W`
4. Paste
`Ctrl + b then ]`

# Set time in linux
1. Disable automate time sync to allow for manual setting
`timedatectl set-ntp false`
2. set time
`date -s "2 OCT 2006 18:00:00"`

# Turn uppercase to lower case
`cat <TEXTFILE> | tr [:upper:] [:lower:]`

# Checking open ports
`netstat -tulpn | grep LISTEN`
`ss -tulpn | grep LISTEN`