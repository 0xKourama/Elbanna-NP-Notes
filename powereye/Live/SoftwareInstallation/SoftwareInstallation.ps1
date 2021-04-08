Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

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

#region invoke the script over the remote computers
$Results = Invoke-Command -ComputerName $Online -ScriptBlock $Script -ErrorAction SilentlyContinue | 
           Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName

#send an email if results were found
if($Results){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html -Fragment | Out-String)"
}