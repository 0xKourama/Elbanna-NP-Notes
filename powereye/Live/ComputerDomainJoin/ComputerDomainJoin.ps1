Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$MinutesSinceCreationThreshold = 60

#query active directory created property and find the ones created within the last 60 minutes
$Result = Get-ADComputer -Filter * -Properties Created |
          Select-Object name,@{Name = 'MinutesSinceCreation';Expression = {(New-TimeSpan -Start $_.Created -End (get-date)).TotalMinutes}} |
          Where-Object {$_.MinutesSinceCreation -lt $MinutesSinceCreationThreshold}

if($Result){
    Write-Output "$(Get-Date) [!] Computer domain join detected. Sending mail"
    Write-Output $Result
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Output "$(Get-Date) [*] No computer domain joins detected."
}