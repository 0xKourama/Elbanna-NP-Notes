Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$PowerShellUserListPath = 'PowerShellUserList.txt'

$PowerShellUserList = Get-Content $PowerShellUserListPath

$Script = {

    $ErrorActionPreference = 'SilentlyContinue'

    $EventID = 800
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

   $Collected_Properties = @(
        'Message'
        'TimeCreated'
    )

    $Results = @()

    if(!(Test-Path -Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Windows Powershell'; ID = $EventID} |
                  Select-Object -Property $Collected_Properties
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Windows Powershell'; ID = $EventID; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property $Collected_Properties
    }

    Get-Date | Export-Clixml -Path $XML_Path

    ForEach ($Event in $Events){
        $Message = $Event.Message -split '\n'
        $Results += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Date         = $Event.TimeCreated
            User         = ($Message | Select-String -Pattern '^\s+UserId=(.*)\s+'      -AllMatches).Matches.Groups[1].Value
            Command      = ($Message | Select-String -Pattern '^\s+CommandLine=(.*)\s+' -AllMatches).Matches.Groups[1].Value
        }
    }
    Write-Output $Results
}

Import-Module '..\UtilityFunctions.ps1'

$Results = Invoke-Command -ComputerName (Return-ADOnlineComputers) -ScriptBlock $Script

$UsersWithActivity = ($Results | Sort-Object -Property User -Unique).User

$UsersWithActivity | ForEach-Object {
    if($PowerShellUserList -notcontains $_){
        $_ >> $PowerShellUserListPath
    }
}

$UnAuthorizedUsage = $Results | Where-Object {$PowerShellUserList -notcontains $_.User}

if($UnAuthorizedUsage){

$UnAuthorizedUsage = @"
<h3>UnAuthorized Usage</h3>
$($UnAuthorizedUsage | ConvertTo-Html -Fragment | Out-String)
"@

$Summary = @"
<h3>Historical Usage Sources</h3>
$($PowerShellUserList | ForEach-Object -Begin {'<ul>'} -Process {"<li>$_</li>"} -End {'</ul>'})
"@

Send-MailMessage @MailSettings -BodyAsHtml "$Style $UnAuthorizedUsage $Summary"

}