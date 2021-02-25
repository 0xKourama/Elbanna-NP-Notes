netsh interface set interface 'Ethernet' Disabled | Out-Null
Write-Host '[!] Ethernet disabled.' -ForeGroundColor Cyan
netsh interface set interface 'Wi-Fi' Enabled | Out-Null
Write-Host '[+] Wi-Fi enabled.' -ForeGroundColor Green