# Sharphound download
https://github.com/BloodHoundAD/BloodHound/blob/master/Collectors/SharpHound.exe

# Usage from windows
```shell
runas.exe /netonly /user:<DOMAIN_FQDN>\<USERNAME> powershell
SharpHound.exe -v 2 -c all --zipfilename bh.zip -d <DOMAIN_FQDN> --domaincontroller <DC_IP>
```