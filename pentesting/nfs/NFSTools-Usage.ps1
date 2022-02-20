Write-Host 'nmap scripts:'
#nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount 10.10.240.134
Write-Host 'nmap -p ' -NoNewline
Write-Host '111 ' -NoNewline -ForegroundColor Green
Write-Host '--script=' -NoNewline
Write-Host 'nfs-ls' -NoNewline -ForegroundColor Green
Write-Host ',' -NoNewline
Write-Host 'nfs-statfs' -NoNewline -ForegroundColor Green
Write-Host ',' -NoNewline
Write-Host 'nfs-showmount RHOST' -NoNewline -ForegroundColor Green