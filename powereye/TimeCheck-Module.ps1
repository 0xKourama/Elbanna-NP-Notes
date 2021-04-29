$Online = Return-ADOnlineComputers
$Index = 0

$Results = @()

$Online | ForEach-Object {
    try{

        $Session = New-PSSession -ComputerName $_ -ErrorAction Stop
        
        $ElapsedMilliSeconds = (Measure-Command -Expression {Invoke-Command -Session $Session -ScriptBlock {Set-Date (Get-Date) -WhatIf}}).TotalMilliseconds

        $Adjusted_Time = Invoke-Command -Session $Session -ScriptBlock {
            $TimeOffsetMilliSeconds = $args[0]
            Set-Date (Get-Date).AddMilliseconds(-$TimeOffsetMilliSeconds) -WhatIf
        } -ArgumentList $ElapsedMilliSeconds

        Remove-PSSession -Session $Session

        $LocalMachineDate    = Get-Date
        $RemoteMachineDate   = $Adjusted_Time.AddMilliSeconds($ElapsedMilliSeconds)
        $TimeOffset          = New-TimeSpan -Start $LocalMachineDate -End $RemoteMachineDate

        $Results += [PSCustomObject][Ordered]@{
            ComputerName           = $_
            LocalMachineDate       = $LocalMachineDate
            RemoteMachineDate      = $RemoteMachineDate
            TimeOffsetSeconds      = $TimeOffset.TotalSeconds
            TimeOffsetMilliSeconds = $TimeOffset.TotalMilliSeconds
            AbsOffsetMilliseconds  = [Math]::Abs($TimeOffset.TotalMilliSeconds)
        }
        $Results | Select-Object -Last 1 | Format-Table -Wrap
    }
    catch{
    
    }
}

$Results | Sort-Object -Property AbsOffsetMilliseconds -Descending | Format-Table -Wrap

Write-Host ($Results | Measure-Object -Property AbsOffsetMilliseconds -Average).Average