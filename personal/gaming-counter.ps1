clear
1800..1|%{Write-Host -ForegroundColor Cyan "[*] $_ seconds remaining";Start-Sleep -Seconds 1};1..3 | %{Write-Host -ForegroundColor Green '[+] Finished!'; Start-Sleep -Seconds 1}
$counter = 14
$hours = $counter/2