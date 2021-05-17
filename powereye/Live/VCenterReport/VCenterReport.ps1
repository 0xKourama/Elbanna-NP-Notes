Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Connect-VIServer -Server 10.5.5.21 -User 'powercli@worldposta.com' -Password 'P@ssw0rdP@ssw0rd'

$Results = Get-VM | Select-Object -Property Name,PowerState,NumCpu,CoresPerSocket,MemoryGB,@{n='UsedSpaceGB';e={[Math]::Round($_.UsedSpaceGB,2)}},Folder,CreateDate

Write-Output "$(Get-Date) [+] Report generated. Sending mail."
Write-Output $Results

Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html -Fragment | Out-String)"