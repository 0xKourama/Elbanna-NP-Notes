param($ComputerName)

Write-Host '[*] Testing connectivity' -ForegroundColor Cyan
$Online = Test-Connection -ComputerName $ComputerName -Count 1 -AsJob |
Wait-Job |
Receive-Job |
Where-Object {$_.StatusCode -eq 0}
if(!$Online){
    Write-Host '[-] Provided computer(s) offline' -ForegroundColor Red
}
else{
    Write-Host '[+] Online computer(s) found' -ForegroundColor Green
    $Online.IPV4Address.IPAddressToString
}