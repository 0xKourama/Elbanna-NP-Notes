$number_of_sets = 30
$hold_duration  = 6
$break_duration = 3
foreach($Loop in (1..$number_of_sets)){
    Write-Host -ForegroundColor Cyan "[*] [$Loop/$number_of_sets]"
    Write-Host -NoNewline -ForegroundColor Green '[+] GO!'
    1..$hold_duration | ForEach-Object {Write-Host -NoNewline -ForegroundColor Green " $_"; Start-Sleep -Seconds 1}
    Write-Host -NoNewline -ForegroundColor Yellow "`n[!] Relax"
    1..$break_duration | ForEach-Object {Write-Host -NoNewline -ForegroundColor Yellow " $_"; Start-Sleep -Seconds 1}
    Write-Host
}