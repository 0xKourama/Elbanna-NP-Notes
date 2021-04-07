$MinutesSinceCreationThreshold = 60
$SleepIntervalSeconds = New-TimeSpan -Minutes $MinutesSinceCreationThreshold

$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'SoftwareInstallation@roaya.co'
    #To         = 'operation@roaya.co'
    To         = 'mgabr@roaya.co'
    Subject    = 'Software Installation'
}

$Style = @"
<style>
th, td {
    border: 2px solid black;
    text-align: center;
}
table{
    border-collapse: collapse;
    border: 2px solid black;
    width: 100%;
}
h3{
    color: white;
    padding: 3px;
    background-color: #2cc900;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header = "<h3>Software Installation</h3>"

$Variables_to_Clear = @(
    'Result'
    'ResultHTML'
)

$Result = Get-ADComputer -Filter * -Properties Created |
          Select-Object name,@{Name = 'MinutesSinceCreation';Expression = {(New-TimeSpan -Start $_.Created -End (get-date)).TotalMinutes}} |
          Where-Object {$_.MinutesSinceCreation -lt $MinutesSinceCreationThreshold}

if($Result -eq $null){
    Write-Host -ForegroundColor Yellow '[!] New computer(s) added to domain. Sending mail'
    $ResultHTML = $Result | ConvertTo-Html | Out-String
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $ResultHTML"
    Clear-Variable -Name $Variables_to_Clear
}
else{
    Write-Host -ForegroundColor Green "[+] No new computers added. Standing by for $($SleepIntervalSeconds.TotalMinutes) minutes"
}
Start-Sleep -Seconds $SleepIntervalSeconds.TotalSeconds