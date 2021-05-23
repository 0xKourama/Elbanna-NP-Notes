Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers, Session, User

Connect-VIServer -Server 10.5.5.20 -User 'powercli@worldposta.com' -Password 'R4Jj2xrJG!9N-h'

$Results = Get-VM | Select-Object -Property Name,PowerState,NumCpu,CoresPerSocket,MemoryGB,@{n='UsedSpaceGB';e={[Math]::Round($_.UsedSpaceGB,2)}},ResourcePool,CreateDate

Write-Output "$(Get-Date) [+] Report generated. Sending mail."
Write-Output $Results

Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html -Fragment | Out-String)"