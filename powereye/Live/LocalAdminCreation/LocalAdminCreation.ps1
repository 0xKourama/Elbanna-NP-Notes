Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $EventID = 4732
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

    $source_pattern        = '^Subject:'
    $target_pattern        = '^Member:'
    $group_pattern         = '^Group:'
    $sid_pattern           = '^\s+Security ID:\s+(.*)\s+$'
    $accountname_pattern   = '^\s+Account Name:\s+(.*)\s+$'
    $accountdomain_pattern = '^\s+Account Domain:\s+(.*)\s+$'
    $groupname_pattern     = '^\s+Group Name:\s+(.*)\s+$'
    $groupdomain_pattern   = '^\s+Group Domain:\s+(.*)\s+$'

    #region parse event messages into an object
    $Events | ForEach-Object {
        $Message = $_.Message -split '\n'

        $source_part = ($Message | Select-String -Pattern $source_pattern -Context 0,3).context.postcontext
        $target_part = ($Message | Select-String -Pattern $target_pattern -Context 0,2).context.postcontext
        $group_part  = ($Message | Select-String -Pattern $group_pattern  -Context 0,3).context.postcontext

        $Results += [PSCustomObject][Ordered]@{
            ComputerName        = $env:COMPUTERNAME
            ChangeDate          = $_.TimeCreated
            ActionSourceSID     = ($source_part | Select-String -Pattern $sid_pattern          ).Matches.Groups[1].Value
            ActionSourceAccount = ($source_part | Select-String -Pattern $accountname_pattern  ).Matches.Groups[1].Value
            ActionSourceDomain  = ($source_part | Select-String -Pattern $accountdomain_pattern).Matches.Groups[1].Value
            TargetAccountSID    = ($target_part | Select-String -Pattern $sid_pattern          ).Matches.Groups[1].Value
            TargetAccount       = (Get-LocalUser -SID ($target_part | Select-String -Pattern $sid_pattern).Matches.Groups[1].Value).Name
            GroupSID            = ($group_part  | Select-String -Pattern $sid_pattern          ).Matches.Groups[1].Value
            GroupName           = ($group_part  | Select-String -Pattern $groupname_pattern    ).Matches.Groups[1].Value
            GroupDomain         = ($group_part  | Select-String -Pattern $groupdomain_pattern  ).Matches.Groups[1].Value
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
    Write-Output "$(Get-Date) [!] Local administrator additions detected. Sending mail."
    Write-Output $Result

    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html)"
}
else{
    Write-Output "$(Get-Date) [*] No Local administrator additions detected."
}