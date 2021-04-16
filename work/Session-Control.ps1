﻿$script = {
    $List = @()
    Try{
        $ErrorActionPreference = 'stop'
        Quser | Select -Skip 1 | ForEach-Object {
            $List += [PSCustomObject][Ordered]@{
                COMPUTERNAME = $env:COMPUTERNAME
                USERNAME     = $_.Substring(1 , 22).Trim().toUpper()
                ID           = $_.Substring(42, 4 ).Trim()
                STATE        = if(($_.Substring(46, 8 ).Trim().toUpper()) -eq 'DISC'){'INACTIVE'}else{'ACTIVE'}
                SESSION      = $_.substring(23,19).Trim().toUpper() -replace '-.*'
                IDLETIME     = $_.substring(54,11).Trim().toUpper()
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
    $List
}
while($true){
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    Write-Host -ForegroundColor Cyan "[*] Running at $(Get-Date)"
    (Invoke-Command -ComputerName (Return-ADOnlineComputers) -ScriptBlock $script -ErrorAction SilentlyContinue |
    Where-Object {$_.username -ne 'NONE' -and $_.idletime -match '\+'} | Sort-Object -Property ComputerName |
    Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceId | Format-Table -AutoSize | Out-String).trim()
    $stopwatch.Stop()
    Write-Host -ForegroundColor Cyan "[*] Task ran in $($stopwatch.Elapsed.TotalSeconds -as [int]) seconds"
    Write-Host -ForegroundColor Yellow ('-' * $Host.UI.RAWUI.MaxWindowSize.Width)
    Start-Sleep -Seconds 3600
}