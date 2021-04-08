$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'SoftwareInstallation@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Software Installation'
}

$Header = "<h3>Software Installation</h3>"

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

$MinutesSinceCreationThreshold = 60

$Result = Get-ADComputer -Filter * -Properties Created |
          Select-Object name,@{Name = 'MinutesSinceCreation';Expression = {(New-TimeSpan -Start $_.Created -End (get-date)).TotalMinutes}} |
          Where-Object {$_.MinutesSinceCreation -lt $MinutesSinceCreationThreshold}

if($Result -eq $null){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html -Fragment | Out-String)"
}
else{
}