Class Module {
    [Bool]$Enabled
    [String]$Name
    [TimeSpan]$RunInterval
    [Int]$TimeoutDurationSeconds
    [Int]$MinutesTillNextRun
    [String]$ScriptDirectory
    [String]$ScriptPath
    [String]$ScriptOutputLog
    [String]$ScriptErrorLog
    [Bool]$RunOnDemand = $false
}
#
$Modules = @(
    #1
    [Module]@{
        Name = 'Admin Group Change'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #2
    [Module]@{
        Name = 'Admin Password Change'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #3
    [Module]@{
        Name = 'Computer Domain Join'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 1
        RunOnDemand = $false
    }
    #4
    [Module]@{
        Name = 'Computer Environment Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 24
        RunOnDemand = $false
    }
    #5
    [Module]@{
        Name = 'Endpoint Missing'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 12
        RunOnDemand = $false
    }
    #6
    [Module]@{
        Name = 'Disk Usage Warning'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 6
        RunOnDemand = $false
    }
    #7
    [Module]@{
        Name = 'Exchange Queue Warning'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #8
    [Module]@{
        Name = 'Mail Latency'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #9
    [Module]@{
        Name = 'Network Bandwidth Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 6
        RunOnDemand = $false
    }
    #10
    [Module]@{
        Name = 'Service Installation'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #11
    [Module]@{
        Name = 'Software Installation'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #12
    [Module]@{
        Name = 'Local Security Group Addition'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #13
    [Module]@{
        Name = 'LAPS Missing'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 12
        RunOnDemand = $false
    }
    #14
    [Module]@{
        Name = 'Session Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 1
        RunOnDemand = $false
    }
    #15
    [Module]@{
        Name = 'Transport Services Restart'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 1
        RunOnDemand = $false
    }
    #16
    [Module]@{
        Name = 'Security Event Log Cleared'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #17
    [Module]@{
        Name = 'Internal Domains DNS Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Days 2
        RunOnDemand = $false
    }
    #18
    [Module]@{
        Name = 'Exchange Servers Status Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 1
        RunOnDemand = $false
    }
    #19
    [Module]@{
        Name = 'Unauthorized Login Detected'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #20
    [Module]@{
        Name = 'VCenter Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Days 1
        RunOnDemand = $false
    }
    #21
    [Module]@{
        Name = 'Local Group Report'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 12
        RunOnDemand = $false
    }
    #22
    [Module]@{
        Name = 'UnAuthorized PowerShell Usage'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 10
        RunOnDemand = $false
    }
    #23
    [Module]@{
        Name = 'AD Monitor'
        Enabled = $true
        RunInterval = New-TimeSpan -Hours 1
        RunOnDemand = $false
    }
    #24
    [Module]@{
        Name = 'Unprotected OUs Detected'
        Enabled = $true
        RunInterval = New-TimeSpan -Days 1
        RunOnDemand = $false
    }
    #25
    [Module]@{
        Name = 'VCenter Storage Monitor'
        Enabled = $true
        RunInterval = New-TimeSpan -Days 1
        RunOnDemand = $false
    }
    #26
    [Module]@{
        Name = 'Exchange Component Reactivation'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 3
        RunOnDemand = $false
    }
    #27 
    [Module]@{
        Name = 'Exchange Service Reactivation'
        Enabled = $true
        RunInterval = New-TimeSpan -Minutes 3
        RunOnDemand = $false
    }
)
if(!$Runtime_Data){
    $Modules | ForEach-Object {$_.MinutesTillNextRun = $_.RunInterval.TotalMinutes}
}
else{
    foreach ($Module in $Modules){
        $Module.MinutesTillNextRun = ($Runtime_Data | Where-Object {$_.Name -eq $Module.Name}).MinutesTillNextRun
    }
}
$Modules | ForEach-Object {
    $_.ScriptDirectory = Join-Path $ScriptRoot -ChildPath ($_.Name -replace ' ')
}
$Modules | ForEach-Object {
    $_.ScriptPath             = Join-Path $_.ScriptDirectory -ChildPath "$($_.Name -replace ' ').ps1"
    $_.ScriptOutputLog        = Join-Path $_.ScriptDirectory -ChildPath "OutputLog.txt"
    $_.ScriptErrorLog         = Join-Path $_.ScriptDirectory -ChildPath "ErrorLog.txt"
    $_.TimeoutDurationSeconds = $_.RunInterval.TotalSeconds
}