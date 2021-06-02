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

$Authorized_PowerShell_Users = @(
	'NT Service\SQLSERVERAGENT'
	'ROAYA\GabrUrgent'
	'ROAYA\maliurgent'
	'ROAYA\pepourgent'
	'ROAYA\solidadmin'
	'ROAYA\SYSTEM'
)

if($UsersWithActivity){

$PowerShellActiveUsers = @"
<h3>Recent Usage</h3>
$($UsersWithActivity | ForEach-Object -Begin {'<ul>'} -Process {"<li>$_</li>"} -End {'</ul>'})
"@

}

$UnAuthorizedUsage = $Results | Where-Object {$Authorized_PowerShell_Users -notcontains $_.User}

if($UnAuthorizedUsage){

$UnAuthorizedUsage = @"
<h3>UnAuthorized Usage</h3>
$($UnAuthorizedUsage | ConvertTo-Html -Fragment | Out-String)
"@

}

$Summary = @"
<h3>Historical Usage Sources</h3>
$(Get-Content $PowerShellUserListPath | ForEach-Object -Begin {'<ul>'} -Process {"<li>$_</li>"} -End {'</ul>'})
"@

if($UsersWithActivity){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $UnAuthorizedUsage $PowerShellActiveUsers $Summary"
}