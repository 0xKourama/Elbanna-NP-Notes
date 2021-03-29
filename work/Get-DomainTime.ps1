Invoke-Command -ComputerName (Test-Connection ((Get-ADComputer -Filter * -Properties IPV4address | Where-Object {$_.IPV4Address} |Select-Object -ExpandProperty Name)) -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} |Select-Object -ExpandProperty Address) -ScriptBlock {$date = Get-Date; $TZ = tzutil /g; Write-Host "$date | $TZ | $env:COMPUTERNAME"} -ErrorAction SilentlyContinue