Class Module {
    [Bool]$Enabled
    [String]$Name
    [TimeSpan]$RunInterval
    [Int]$MinutesTillNextRun
    [String]$ScriptPath
    [Bool]$RunOnDemand = $false
}

$Modules = @(
    #1
    [Module]@{
        Enabled = $true
        Name = 'Admin Group Change'
        RunInterval = New-TimeSpan -Minutes 10
        ScriptPath = "$ScriptRoot\AdminGroupChange.ps1"
    }
    #2
    [Module]@{
        Enabled = $true
        Name = 'Admin Password Change'
        RunInterval = New-TimeSpan -Minutes 10
        ScriptPath = "$ScriptRoot\AdminPasswordChange.ps1"
    }
    #3
    [Module]@{
        Enabled = $true
        Name = 'Computer Domain Join'
        RunInterval = New-TimeSpan -Hours 1
        ScriptPath = "$ScriptRoot\ComputerDomainJoin.ps1"
    }
    #4
    [Module]@{
        Enabled = $true
        Name = 'Computer Environment Report'
        RunInterval = New-TimeSpan -Hours 24
        ScriptPath = "$ScriptRoot\ComputerEnvironmentReport.ps1"
    }
    #5
    [Module]@{
        Enabled = $true
        Name = 'Cortex Endpoint Missing'
        RunInterval = New-TimeSpan -Hours 12
        ScriptPath = "$ScriptRoot\CortexEndpointMissing.ps1"
    }
    #6
    [Module]@{
        Enabled = $true
        Name = 'Disk Usage Warning'
        RunInterval = New-TimeSpan -Hours 6
        ScriptPath = "$ScriptRoot\DiskUsageWarning.ps1"
    }
    #7
    [Module]@{
        Enabled = $true
        Name = 'Exchange Queue Warning'
        RunInterval = New-TimeSpan -Minutes 10
        ScriptPath = "$ScriptRoot\ExchangeQueueWarning.ps1"
    }
    #8
    [Module]@{
        Enabled = $true
        Name = 'Mail Latency'
        RunInterval = New-TimeSpan -Minutes 10
        ScriptPath = "$ScriptRoot\MailLatency.ps1"
    }
    #9
    [Module]@{
        Enabled = $true
        Name = 'Network Bandwidth Report'
        RunInterval = New-TimeSpan -Hours 6
        ScriptPath = "$ScriptRoot\NetworkBandwidthReport.ps1"
    }
    #10
    [Module]@{
        Enabled = $true
        Name = 'Service Installation'
        RunInterval = New-TimeSpan -Minutes 10
        ScriptPath = "$ScriptRoot\ServiceInstallation.ps1"
    }
    #11
    [Module]@{
        Enabled = $true
        Name = 'Software Installation'
        RunInterval = New-TimeSpan -Minutes 10
        ScriptPath = "$ScriptRoot\SoftwareInstallation.ps1"
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