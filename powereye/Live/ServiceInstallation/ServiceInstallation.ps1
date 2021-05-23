Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

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

Import-Module '..\UtilityFunctions.ps1'

#region test connectivity to all domain computers
$Online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name
#endregion

#region invoke the script over the remote computers
$Results = Invoke-Command -ComputerName $Online -ScriptBlock $Script -ErrorAction SilentlyContinue |
           Where-Object {
                ($_.ServiceFileName -notlike 'C:\ProgramData\Microsoft\Windows Defender\Definition Updates\*') -and ($_.ServiceName -ne 'VeeamVssSupport')
            } |
           Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
#endregion

#send an email if results were found
if($Results){
    Write-Output "$(Get-Date) [!] New service installation(s) detected. Sending mail."
    Write-Output $Results

    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Output "$(Get-Date) [*] No new service installation(s) detected."
}