$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'SoftwareInstallation@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Software Installation'
}

#region HTML layout
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
    background-color: #ebc402;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@
#endregion

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $EventID = 11707
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

    $Results = @()

    #region if the date of last query is found, we query events from that point forward, otherwise, we query all events
    if(!(Test-Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Application'; ID = $EventID} | Select-Object -Property Message,TimeCreated
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Application'; ID = $EventID; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property Message,TimeCreated
    }

    #update the tracker XML file
    Get-Date | Export-Clixml -Path $XML_Path
    #endregion

    #region parse event message into an object
    $Events | ForEach-Object {
        $Results += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Date         = $_.TimeCreated
            Product      = ($_.Message | Select-String -Pattern "^Product: (.*) -- Installation completed successfully.$" -AllMatches).Matches.Groups[1].Value
        }
    }
    #endregion

    Write-Output $Results
}

#region test connectivity to all domain computers
$Online = (Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
            Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0}).Address
#endregion

#region invoke the script over the remote computers
$Results = Invoke-Command -ComputerName $Online -ScriptBlock $Script -ErrorAction SilentlyContinue | 
            Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
#endregion

#send an email if results were found
if($Results){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html -Fragment | Out-String)"
}