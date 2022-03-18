Clear-Host
Write-Host 'Nmap Scripts:'
Write-Host 'nmap ' -NoNewline
Write-Host 'RHOST ' -ForegroundColor Green -NoNewline
write-host '-p ' -NoNewline
Write-Host '445 ' -NoNewline -ForegroundColor Green
Write-Host '--script=' -NoNewline
Write-Host 'smb-enum-shares.nse' -NoNewline -ForegroundColor Green
Write-Host ',' -NoNewline
Write-Host 'smb-enum-users.nse '-ForegroundColor Green
###################
Write-Host
Write-Host 'enum4linux:'
Write-Host 'enum4linux ' -NoNewline
Write-Host 'RHOST ' -NoNewline -ForegroundColor Green
write-host '-a -u ' -NoNewline
Write-Host 'USER ' -NoNewline -ForegroundColor Green
Write-Host '-p ' -NoNewline
Write-Host 'PASSWORD' -ForegroundColor Green
###################
Write-Host
Write-Host 'smbclient:'
Write-Host 'smbclient //' -NoNewline
Write-Host 'RHOST' -NoNewline -ForegroundColor Green
Write-Host '/' -NoNewline
Write-Host 'SHARE '-ForegroundColor Green -NoNewline
Write-Host '-I ' -NoNewline
Write-Host 'IP ' -ForegroundColor Green -NoNewline
Write-Host '-p ' -NoNewline
Write-Host 'PORT ' -ForegroundColor Green -NoNewline
Write-Host '-U ' -NoNewline
Write-Host 'USER ' -NoNewline -ForegroundColor Green
Write-Host '--pw-nt-hash ' -NoNewline
Write-Host 'HASH ' -NoNewline -ForegroundColor Green
Write-Host '-m ' -NoNewline
Write-Host 'MAXPROTOCOLLEVEL ' -ForegroundColor Green -NoNewline
Write-Host '-d ' -NoNewline
Write-Host 'DEBUGLEVEL ' -NoNewline -ForegroundColor Green
Write-Host '-W ' -NoNewline
Write-Host 'WORKGROUP '-ForegroundColor Green
Write-Host '          -L ' -NoNewline
Write-Host '[List Shares]' -ForegroundColor Cyan
Write-Host '          -N ' -NoNewline
Write-Host '[No Password]' -ForegroundColor Cyan
Write-Host '          -e ' -NoNewline
Write-Host '[Encrypt Traffic]' -ForegroundColor Cyan
###################
Write-Host
Write-Host 'smbmap:'
Write-Host 'smbmap -H ' -NoNewline
Write-Host 'RHOST ' -NoNewline -ForegroundColor Green
Write-Host '-u ' -NoNewline
Write-Host 'USER ' -NoNewline -ForegroundColor Green
Write-Host '-p ' -NoNewline
Write-Host 'PASSWORD/NT:LM ' -NoNewline -ForegroundColor Green
Write-Host '-s ' -NoNewline
Write-Host 'SHARE ' -NoNewline -ForegroundColor Green
Write-Host '-d ' -NoNewline
Write-Host 'DOMAIN ' -NoNewline -ForegroundColor Green
Write-Host '-P ' -NoNewline
Write-Host 'PORT ' -NoNewline -ForegroundColor Green
Write-Host '-x ' -NoNewline
Write-Host 'COMMAND '-ForegroundColor Green
Write-Host '       -v ' -NoNewline
Write-Host '[Show OS version] '-ForegroundColor Cyan
Write-Host '       -download ' -NoNewline
Write-Host 'FILEPATH '-ForegroundColor Cyan
Write-Host '       -upload ' -NoNewline
Write-Host 'SRC DST '-ForegroundColor Cyan
Write-Host '       -delete ' -NoNewline
Write-Host 'FILEPATH '-ForegroundColor Cyan