foreach($Loop in (1..30)){
    Write-Host -ForegroundColor Cyan "[*] [$Loop/30]"
    Write-Host -NoNewline -ForegroundColor Green '[+] GO!'
    1..5 | ForEach-Object {Write-Host -NoNewline -ForegroundColor Green " $_"; Start-Sleep -Seconds 1}
    Write-Host -NoNewline -ForegroundColor Yellow "`n[!] Relax"
    1..3 | ForEach-Object {Write-Host -NoNewline -ForegroundColor Yellow " $_"; Start-Sleep -Seconds 1}
    Write-Host
}