$services = @(
    'mail'
    'imap'
    'mapi'
    'autodiscover'
    'rpc'
    'async'
)
ipconfig /flushdns | Out-Null
Write-Host '[+] Local DNS Cache flushed' -ForegroundColor Green
$services | ForEach-Object {
    Write-Host "[*] Resolving $($_.toUpper()) service" -ForegroundColor Cyan
    $result = Resolve-DnsName -Name "$_.worldposta.com" | Select-Object -Property Name, IPAddress
    foreach($res in $result){
        Write-Host "$($res.Name): $($res.IPAddress)"
    }
    Write-Host
}
Write-Host '[+] Execution completed' -ForegroundColor Green