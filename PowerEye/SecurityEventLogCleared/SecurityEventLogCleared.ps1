Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $EventID = 1102
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

    $Results = @()

    #region if the date of last query is found, we query events from that point forward, otherwise, we query all events
    if(!(Test-Path -Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID} |
                  Select-Object -Property Message, TimeCreated
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property Message, TimeCreated
    }
    #update the tracker XML file
    Get-Date | Export-Clixml -Path $XML_Path
    #endregion

    #region parse event messages into an object
    $Events | ForEach-Object {
        $Message = $_.Message -split '\n'

        $Results += [PSCustomObject][Ordered]@{
            ComputerName  = $env:COMPUTERNAME
            Date          = $_.TimeCreated
            SID           = ($Message | Select-String -Pattern '^\s+Security ID:\s+(.*)\s+$').Matches.Groups[1].Value
            AccountName   = ($Message | Select-String -Pattern '^\s+Account Name:\s+(.*)\s+$').Matches.Groups[1].Value
            AccountDomain = ($Message | Select-String -Pattern '^\s+Domain Name:\s+(.*)\s+$').Matches.Groups[1].Value
        }
    }
    #endregion

    Write-Output $Results
}

Import-Module '..\UtilityFunctions.ps1'

#testing connectivity for all domain computers
$Online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name

#invoke the script over the remote computers
$Result = Invoke-Command -ComputerName $Online -ScriptBlock $Script |
          Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName, PSComputerName |
          Sort-Object -Property ChangeDate -Descending

if($Result){
    Write-Output "$(Get-Date) [!] Security Event log clear(s) detected. Sending mail."
    Write-Output $Result

    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html)"
}
else{
    Write-Output "$(Get-Date) [*] No Security Event log clear(s) detected."
}