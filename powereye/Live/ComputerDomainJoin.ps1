$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'ComputerDomainJoin@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Computer Domain Join'
}

#region HTML layout
$Header = "<h3>Computer Domain Join</h3>"

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
#endregion

$MinutesSinceCreationThreshold = 60

#query active directory created property and find the ones created within the last 60 minutes
$Result = Get-ADComputer -Filter * -Properties Created |
          Select-Object name,@{Name = 'MinutesSinceCreation';Expression = {(New-TimeSpan -Start $_.Created -End (get-date)).TotalMinutes}} |
          Where-Object {$_.MinutesSinceCreation -lt $MinutesSinceCreationThreshold}

if($Result){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html -Fragment | Out-String)"
}