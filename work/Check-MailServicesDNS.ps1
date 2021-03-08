$services = @(
    'mail'
    'imap'
    'mapi'
    'autodiscover'
)
$results = @()
$services | ForEach-Object {
    $results += Resolve-DnsName -Name "$_.worldposta.com" | Select-Object -Property Name, IPAddress
}
$results | Format-Table -AutoSize