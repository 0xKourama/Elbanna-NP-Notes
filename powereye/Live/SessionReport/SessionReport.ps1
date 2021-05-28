Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Import-Module '..\UtilityFunctions.ps1'

$session_script = {
    $List = @()
    Try{
        $ErrorActionPreference = 'stop'
        Quser | Select -Skip 1 | ForEach-Object {
            $IdleString = $_.substring(54,11).Trim().toUpper()
            if($IdleString -eq 'NONE'){
                $IdleMinutes = 0
                $IdleHours   = 0
                $IdleDays    = 0
            }
            elseif($IdleString -notmatch ':'){
                $IdleMinutes = $IdleString
                $IdleHours   = 0
                $IdleDays    = 0
            }
            elseif($IdleString -notmatch '\+'){
                $Groups = ($IdleString | Select-String -Pattern "(?<Hours>\d{1,2}):(?<Minutes>\d{1,2})").Matches.Groups
                $IdleMinutes = ($Groups | Where-Object {$_.Name -eq 'Minutes'}).Value
                $IdleHours   = ($Groups | Where-Object {$_.Name -eq 'Hours'  }).Value
                $IdleDays    = 0
            }
            else{
                $Groups = ($IdleString | Select-String -Pattern "(?<Days>\d{1,2})\+(?<Hours>\d{1,2}):(?<Minutes>\d{1,2})").Matches.Groups
                $IdleMinutes = ($Groups | Where-Object {$_.Name -eq 'Minutes'}).Value
                $IdleHours   = ($Groups | Where-Object {$_.Name -eq 'Hours'  }).Value
                $IdleDays    = ($Groups | Where-Object {$_.Name -eq 'Days'   }).Value
            }
            $List += [PSCustomObject][Ordered]@{
                ComputerName = $env:COMPUTERNAME
                Username     = $_.Substring(1 , 22).Trim().toUpper()
                ID           = $_.Substring(42, 4 ).Trim()
                LogonTime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
                State        = if(($_.Substring(46, 8 ).Trim().toUpper()) -eq 'DISC'){'INACTIVE'}else{'ACTIVE'}
                SessionType  = $_.substring(23,19).Trim().toUpper() -replace '-.*'
                IdleDuration = "$IdleDays day(s) $IdleHours hour(s) $IdleMinutes minute(s)"
                IdleSpan     = New-TimeSpan -Days $IdleDays -Hours $IdleHours -Minutes $IdleMinutes
            }
        }
    }
    Catch{
        $List += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = 'NONE'
        }
    }
    Write-Output $List
}

$Online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name

$session_summary = Invoke-Command -ComputerName $Online -ErrorAction SilentlyContinue -ScriptBlock $session_script | Where-Object {$_.ComputerName -ne 'PowerEye'} |
                   Sort-Object -Property ComputerName | Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceID

[PSCustomObject[]]$session_CONSOLE_summary  = $session_summary | Where-Object {$_.SessionType -eq 'CONSOLE' } | Select-Object -Property * -ExcludeProperty IdleSpan, ID
[PSCustomObject[]]$session_RDP_summary      = $session_summary | Where-Object {$_.SessionType -eq 'RDP'     } | Select-Object -Property * -ExcludeProperty IdleSpan, ID
[PSCustomObject[]]$session_inactive_summary = $session_summary | Where-Object {$_.State       -eq 'INACTIVE'} | Select-Object -Property * -ExcludeProperty SessionType, IdleSpan, ID

$LogoffScript = {
    logoff $args[0]
    if($?){
        [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = $args[1]
            LogoffResult = 'Success'
        }
    }
    else{
        [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = $args[1]
            LogoffResult = 'Fail'
        }
    }
}

$LogoffResults = @()

$Idle_sessions = $session_summary | Where-Object {$_.IdleSpan.TotalHours -ge 3}

$Idle_sessions | ForEach-Object {
    $LogoffResults += Invoke-Command -ComputerName $_.ComputerName -ScriptBlock $LogoffScript -ArgumentList $_.ID, $_.Username |
                      Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
}

#region HTML summary data
if($session_CONSOLE_summary){
$ConsoleSection = @"
<h3>Console Sessions ($($session_CONSOLE_summary.count))</h3>
$($session_CONSOLE_summary | ConvertTo-Html -Fragment)
"@
}

if($session_RDP_summary){
$RDPSection = @"
<h3>RDP Sessions ($($session_RDP_summary.count))</h3>
$($session_RDP_summary      | ConvertTo-Html -Fragment)
"@
}

if($session_inactive_summary){
$InactiveSection = @"
<h3>Inactive Sessions ($($session_inactive_summary.count))</h3>
$($session_inactive_summary | ConvertTo-Html -Fragment)
"@
}

if($LogoffResults){
$CleanUpSection = @"
<h3>Sessions terminated for inactivity exceeding 3 hours ($($LogoffResults.Count))</h3>
$($LogoffResults | ConvertTo-Html -Fragment)
"@
}
#endregion

Write-Output "$(Get-Date) [*] Sending mail"

Write-Output $session_CONSOLE_summary
Write-Output $session_RDP_summary
Write-Output $session_inactive_summary

if($session_CONSOLE_summary -or $session_RDP_summary -or $session_inactive_summary){
    Write-Output "$(Get-Date) [*] Sessions were found. Sending mail."
    Send-MailMessage @MailSettings -BodyAsHtml "$style $ConsoleSection $RDPSection $InactiveSection $CleanUpSection"
}
else{
    Write-Output "$(Get-Date)[-] No Sessions were found"
}