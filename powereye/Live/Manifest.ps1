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
        Enabled = $true
        Name = 'Admin Group Change'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #2
    [Module]@{
        Enabled = $true
        Name = 'Admin Password Change'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #3
    [Module]@{
        Enabled = $true
        Name = 'Computer Domain Join'
        RunInterval = New-TimeSpan -Hours 1
    }
    #4
    [Module]@{
        Enabled = $true
        Name = 'Computer Environment Report'
        RunInterval = New-TimeSpan -Hours 24
    }
    #5
    [Module]@{
        Enabled = $true
        Name = 'Cortex Endpoint Missing'
        RunInterval = New-TimeSpan -Hours 12
    }
    #6
    [Module]@{
        Enabled = $true
        Name = 'Disk Usage Warning'
        RunInterval = New-TimeSpan -Hours 6
    }
    #7
    [Module]@{
        Enabled = $true
        Name = 'Exchange Queue Warning'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #8
    [Module]@{
        Enabled = $true
        Name = 'Mail Latency'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #9
    [Module]@{
        Enabled = $true
        Name = 'Network Bandwidth Report'
        RunInterval = New-TimeSpan -Hours 6
    }
    #10
    [Module]@{
        Enabled = $true
        Name = 'Service Installation'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #11
    [Module]@{
        Enabled = $true
        Name = 'Software Installation'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #12
    [Module]@{
        Enabled = $true
        Name = 'Local Security Group Addition'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #13
    [Module]@{
        Enabled = $true
        Name = 'LAPS Missing'
        RunInterval = New-TimeSpan -Hours 12
    }
    #14
    [Module]@{
        Enabled = $true
        Name = 'Session Report'
        RunInterval = New-TimeSpan -Hours 1
    }
    #15
    [Module]@{
        Enabled = $true
        Name = 'Transport Services Restart'
        RunInterval = New-TimeSpan -Hours 1
    }
    #16
    [Module]@{
        Enabled = $true
        Name = 'Security Event Log Cleared'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #17
    [Module]@{
        Enabled = $true
        Name = 'Internal Domains DNS Report'
        RunInterval = New-TimeSpan -Days 2
    }
    #18
    [Module]@{
        Enabled = $true
        Name = 'Exchange Servers Status Report'
        RunInterval = New-TimeSpan -Hours 1
    }
    #19
    [Module]@{
        Enabled = $true
        Name = 'Unauthorized Login Detected'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #20
    [Module]@{
        Enabled = $true
        Name = 'VCenter Report'
        RunInterval = New-TimeSpan -Days 1
    }
    #21
    [Module]@{
        Enabled = $true
        Name = 'Local Group Report'
        RunInterval = New-TimeSpan -Hours 12
    }
    #22
    [Module]@{
        Enabled = $true
        Name = 'UnAuthorized PowerShell Usage'
        RunInterval = New-TimeSpan -Minutes 10
    }
    #23
    [Module]@{
        Enabled = $true
        Name = 'AD Monitor'
        RunInterval = New-TimeSpan -Hours 1
    }
    #24
    [Module]@{
        Enabled = $true
        Name = 'Unprotected OUs Detected'
        RunInterval = New-TimeSpan -Days 1
    }
    #25
    [Module]@{
        Enabled = $true
        Name = 'VCenter Storage Monitor'
        RunInterval = New-TimeSpan -Days 1
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