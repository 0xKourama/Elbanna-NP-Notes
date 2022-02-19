Param($url)
Write-Host "[*] Sending web request to $url" -ForegroundColor Cyan
(Invoke-WebRequest -Uri $URL ).Links.Href
Write-Host '[+] URL extraction complete' -ForegroundColor Green