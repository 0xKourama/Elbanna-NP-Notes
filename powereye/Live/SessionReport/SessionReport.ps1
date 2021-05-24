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
                IdleDays     = $IdleDays
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

$session_CONSOLE_summmary = $session_summary | Where-Object {$_.SessionType -eq 'CONSOLE' } | Select-Object -Property * -ExcludeProperty IdleDays, ID
$session_RDP_summary      = $session_summary | Where-Object {$_.SessionType -eq 'RDP'     } | Select-Object -Property * -ExcludeProperty IdleDays, ID
$session_INACTIVE_summary = $session_summary | Where-Object {$_.State       -eq 'INACTIVE'} | Select-Object -Property * -ExcludeProperty SessionType, IdleDays, ID

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

$Idle_sessions = $session_summary | Where-Object {$_.IdleDays -ge 1}

$Idle_sessions | ForEach-Object {
    $LogoffResults += Invoke-Command -ComputerName $_.ComputerName -ScriptBlock $LogoffScript -ArgumentList $_.ID, $_.Username |
                      Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
}

#region HTML summary data
$body = @"
<h3>Console Sessions ($($session_CONSOLE_summmary.count))</h3>
$($session_CONSOLE_summmary | ConvertTo-Html -Fragment)
<h3>RDP Sessions ($($session_RDP_summmary.count))</h3>
$($session_RDP_summary      | ConvertTo-Html -Fragment)
<h3>Inactive Sessions ($($session_INACTIVE_summmary.count))</h3>
$($session_inactive_summary | ConvertTo-Html -Fragment)
"@

if($LogoffResults){

$Footer = @"
<h3>Sessions terminated for inactivity exceeding 1 day ($($Idle_sessions.Count))</h3>
$($LogoffResults | ConvertTo-Html -Fragment)
"@

}
#endregion

Write-Output "$(Get-Date) [*] Sending mail"

Write-Output $session_CONSOLE_summmary
Write-Output $session_RDP_summary
Write-Output $session_inactive_summary

Send-MailMessage @MailSettings -BodyAsHtml "$style $body $Footer"