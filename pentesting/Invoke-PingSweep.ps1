param($Subnet)
if(!$Subnet){Write-Host "[!] Usage: Invoke-PingSweep -Subnet 192.168.1" -ForegroundColor Yellow}
else{
    Write-Host "[*] Sweeping the $Subnet subnet" -ForegroundColor Cyan
    Test-Connection -ComputerName (1..254 | ForEach-Object {"$Subnet.$_"}) -Count 1 -AsJob | 
    Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} |
    ForEach-Object {Write-Host "[+] $($_.Address) up" -ForegroundColor Green}
    Write-Host "[*] Sweep finished" -ForegroundColor Cyan
}