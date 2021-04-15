Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Import-Module '..\UtilityFunctions.ps1'

$session_script = {
    $PropertyList = @(
        'ComputerName'
        'Username'
        'Logontime'
        'Status'
    )
    $User_list = @()
    try{
        Quser | Select-Object -Skip 1 | ForEach-Object {
            $User = @{} | Select-Object -Property $PropertyList
            $User.ComputerName = $env:COMPUTERNAME
            $User.username     = $_.Substring(0 , 23).Trim().toUpper()
            $state             = $_.Substring(46, 8 ).Trim().toUpper()
            if($state -eq 'Disc'){$User.status = 'INACTIVE'}
            else{
                $session = $_.Substring(22, 20).Trim().toUpper()
                if($session -like 'RDP*'){$session = 'RDP'  }
                else                     {$session = 'CONSOLE'}
                $User.status = "ACTIVE - $session"
            }
            $User.logontime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
            $User_list += $User
        }
    }
    catch{
        $User = @{} | Select-Object -Property $PropertyList
        $User.ComputerName = $env:COMPUTERNAME
        $User.Username = "NONE"
        $User_list    += $User        
    }
    Write-Output $User_list
}

$Online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name

$session_summary = Invoke-Command -ComputerName $Online -ErrorAction SilentlyContinue -ScriptBlock $session_script |
                   Sort-Object -Property ComputerName | Select-Object -Property ComputerName, Username, LogonTime, Status

$session_RDP_summary      = $session_summary | Where-Object {$_.Status -eq 'ACTIVE - RDP'    }
$session_CONSOLE_summmary = $session_summary | Where-Object {$_.Status -eq 'ACTIVE - CONSOLE'}
$session_inactive_summary = $session_summary | Where-Object {$_.Status -eq 'INACTIVE'        }

#region HTML summary data
$body = @"
<h3>Console Sessions</h3>
$($session_CONSOLE_summmary | ConvertTo-Html -Fragment)
<h3>RDP Sessions</h3>
$($session_RDP_summary      | ConvertTo-Html -Fragment)
<h3>Inactive Sessions</h3>
$($session_inactive_summary | ConvertTo-Html -Fragment)
"@
#endregion

Write-Output "$(Get-Date) [*] Sending mail"

Write-Output $session_CONSOLE_summmary
Write-Output $session_RDP_summary
Write-Output $session_inactive_summary

Send-MailMessage @MailSettings -BodyAsHtml "$style $body"