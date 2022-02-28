Write-Host 'Nmap usage:'
Write-Host -NoNewline 'nmap '
Write-Host -NoNewline -ForegroundColor Green '<RHOST> '
Write-Host -NoNewline -ForegroundColor Cyan '-sC [Default Scripts] '
Write-Host -NoNewline -ForegroundColor Cyan '-sV [Service Detection] '
Write-Host -NoNewline -ForegroundColor Cyan '-p- [All Ports] '
Write-Host -NoNewline '-oN '
Write-Host -NoNewline -ForegroundColor Green '[Output File]'