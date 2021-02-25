netsh interface set interface 'Wi-Fi' Disabled | Out-Null
Write-Host '[!] Wi-Fi disabled.' -ForeGroundColor Cyan
netsh interface set interface 'Ethernet' Enabled | Out-Null
Write-Host '[+] Ethernet enabled.' -ForeGroundColor Green