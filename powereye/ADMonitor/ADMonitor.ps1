Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $EventList = @(
        4720, #user created
        4726, #user deleted
        4722, #user enabled
        4725, #user disabled
        4723, #user changed his own password
        4724, #admin changed a user's password
        4738, #user changed
        4740, #user locked out
        4767, #user unlocked
        4781, #user name changed

        4741, #Computer account created
        4742, #Computer account changed
        4743, #Computer account was deleted

        4764, #Groups type changed

        4731, #local sec group created
        4735, #local sec group changed
        4734, #local sec group deleted
        4732, #local sec group member added
        4733, #local sec group member removed

        4727, #global sec group created
        4737, #global sec group changed
        4730, #global sec group deleted
        4728, #global sec group member added
        4729, #global sec group member removed

        4754, #universal sec group created
        4755, #universal sec group changed
        4758, #universal sec group deleted
        4756, #universal sec group member added
        4757, #universal sec group member removed

        4744, #local distribution group created
        4745, #local distribution group changed
        4748, #local distribution group deleted
        4746, #local distribution group member added
        4747, #local distribution group member removed

        4749, #global distribution group created
        4750, #global distribution group changed
        4753, #global distribution group deleted
        4751, #global distribution group member added
        4752, #global distribution group member removed

        4759, #universal distribution group created
        4760, #universal distribution group changed
        4763, #universal distribution group deleted
        4761, #universal distribution group member added
        4762, #universal distribution group member removed

        5137, #ADobject Created
        5136, #ADObject Modified
        5139, #ADObject Moved
        5141, #ADObject deleted
        5138, #ADObject Undeleted

        4794, #Attempt to set DSRM Administrator password

        5376, #Credential Manager credentials backed up
        5377  #Credential Manager credentials restored from backedup
    )

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