$Domains = (Import-Csv "~\Desktop\WorldPosta Domains.csv").Domain
$count = $Domains.count
$index = 0
$Domains | ForEach-Object {
    $index++
    write-host -ForegroundColor Cyan "[*] [$index/$count] Querying $_"
    try{
        (Resolve-DnsName -Type SRV -Name "_autodiscover._tcp.$_" -ErrorAction stop | Out-String).trim()
    }
    catch{
        Write-Host -ForegroundColor Red "Error $_"
    }
    Write-Host -ForegroundColor Yellow ('-' * $Host.UI.RAWUI.MaxWindowSize.Width)
    pause
}