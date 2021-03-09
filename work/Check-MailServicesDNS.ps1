$services = @(
    'mail'
    'imap'
    'mapi'
    'autodiscover'
)
ipconfig /flushdns | Out-Null
Write-Host '[+] Local DNS Cache flushed' -ForegroundColor Green
$results = @()
$services | ForEach-Object {
    $results += Resolve-DnsName -Name "$_.worldposta.com" | Select-Object -Property Name, IPAddress
}
$results | Format-Table -AutoSize