foreach($Loop in (1..30)){
    Write-Host -ForegroundColor Cyan "[*] [$Loop/30]"
    Write-Host -NoNewline -ForegroundColor Green '[+] GO!'
    5..1 | ForEach-Object {Write-Host -NoNewline -ForegroundColor Green " $_"; Start-Sleep -Seconds 1}
    Write-Host -ForegroundColor Green ' 0'; Start-Sleep -Seconds 1
    Write-Host -NoNewline -ForegroundColor Yellow '[!] Wait'
    3..1 | ForEach-Object {Write-Host -NoNewline -ForegroundColor Yellow " $_"; Start-Sleep -Seconds 1}
    Write-Host -ForegroundColor Yellow ' 0'; Start-Sleep -Seconds 1
}