$script = {
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
                COMPUTERNAME = $env:COMPUTERNAME
                USERNAME     = $_.Substring(1 , 22).Trim().toUpper()
                ID           = $_.Substring(42, 4 ).Trim()
                STATE        = if(($_.Substring(46, 8 ).Trim().toUpper()) -eq 'DISC'){'INACTIVE'}else{'ACTIVE'}
                SESSION      = $_.substring(23,19).Trim().toUpper() -replace '-.*'
                IDLEDAYS     = $IdleDays
                IDLEHOURS    = $IdleHours
                IDLEMINUTES  = $IdleMinutes
                LOGONTIME    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
            }
        }
    }
    Catch{
        $List += [PSCustomObject][Ordered]@{
            COMPUTERNAME = $env:COMPUTERNAME
            USERNAME = 'NONE'
        }
    }
    Write-Output $List
}
#while($true){
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
Write-Host -ForegroundColor Cyan "[*] Running at $(Get-Date)"
(Invoke-Command -ComputerName (Return-ADOnlineComputers) -ScriptBlock $script -ErrorAction SilentlyContinue |
Where-Object {$_.username -ne 'NONE' <#-and $_.idletime -match '\+'#>} | Sort-Object -Property ComputerName |
Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceId | Format-Table -AutoSize | Out-String).trim()
$stopwatch.Stop()
Write-Host -ForegroundColor Cyan "[*] Task ran in $($stopwatch.Elapsed.TotalSeconds -as [int]) seconds"
Write-Host -ForegroundColor Yellow ('-' * $Host.UI.RAWUI.MaxWindowSize.Width)
#Start-Sleep -Seconds 3600
#}