$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'ServiceInstallation@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Service Installation'
}

#region HTML layout
$Header = "<h3>Service Installation</h3>"

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
    background-color: #0596F4;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@
#endregion

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $Results = @()
    $EventID = 7045
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

    #region if the date of last query is found, we query events from that point forward, otherwise, we query all events
    if(!(Test-Path -Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'System'; ID = 7045} | Select-Object -Property Message, TimeCreated
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'System'; ID = 7045; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property Message, TimeCreated
    }
    #update the tracker XML file
    Get-Date | Export-Clixml -Path $XML_Path
    #endregion

    #region parse event message into an object
    foreach($Event in $Events){
        $SplitMessage = $Event.Message -split '\n'
        $Results += [PSCustomObject][Ordered]@{
            ComputerName      = $env:COMPUTERNAME
            Date              = $Event.TimeCreated
            ServiceName       = ($SplitMessage | Select-String -Pattern "^Service Name:  (.*)$"       -AllMatches).Matches.Groups[1].Value
            ServiceFileName   = ($SplitMessage | Select-String -Pattern "^Service File Name:  (.*)$"  -AllMatches).Matches.Groups[1].Value
            ServiceType       = ($SplitMessage | Select-String -Pattern "^Service Type:  (.*)$"       -AllMatches).Matches.Groups[1].Value
            ServiceStartType  = ($SplitMessage | Select-String -Pattern "^Service Start Type:  (.*)$" -AllMatches).Matches.Groups[1].Value
            ServiceAccount    = ($SplitMessage | Select-String -Pattern "^Service Account:  (.*)$"    -AllMatches).Matches.Groups[1].Value
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