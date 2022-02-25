Param([string[]]$IP)
$API_key = '18c878690f2c8c081485c10abb136019d470158631d0eced7bb8269b432db49e'
$Results = @()
$Index = 0
$IPCounter = $IP.count
foreach($address in $IP){
    $Index++
    $IPCounter--
    Write-Host -ForegroundColor Cyan "[*] [$Index/$($IP.count)] Querying Virus Total for IP: $address"
    $Response = Invoke-WebRequest "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$API_key&ip=$address" | ConvertFrom-Json
    ($Response | Format-List | Out-String).Trim()
    $Results += $Response
    write-host -ForegroundColor Yellow $('-' * $Host.UI.RAWUI.MaxWindowSize.Width)
    $TimeToFinish = New-TimeSpan -Seconds ($IPCounter * 15)
    $message = "[*] ETA: $($TimeToFinish.Days) days $($TimeToFinish.hours) hours $($TimeToFinish.Minutes) minutes $($TimeToFinish.Seconds) seconds."
    Write-Host -ForegroundColor Cyan $message
    Start-Sleep -Seconds 15
}
Write-Host -ForegroundColor Green '[+] Results exported to Results.txt'
$Results > Results.txt