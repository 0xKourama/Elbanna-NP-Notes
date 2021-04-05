$ScriptRoot = 'C:\Users\Zen\PowerShell\powereye\development'

Class Module {
    [bool]$Enabled
    [string]$Name
    [int]$RunIntervalMinutes
    [int]$MinutesTillNextRun
    [string]$ScriptPath
}

$State = Import-Clixml "$ScriptRoot\state.xml"
#
$Modules = @(
    
    #1
    [Module]@{
        Enabled = $true
        Name = 'Exchange Queue'
        RunIntervalMinutes = 10
        MinutesTillNextRun = $State | Where-Object {$_.Name -eq 'Exchange Queue'} | Select-Object -ExpandProperty MinutesTillNextRun
        ScriptPath = "$ScriptRoot"
    }

    #2
    [Module]@{
        Enabled = $true
        Name = 'Mail Latency'
        RunIntervalMinutes = 10
        MinutesTillNextRun = $State | Where-Object {$_.Name -eq 'Mail Latency'} | Select-Object -ExpandProperty MinutesTillNextRun
        ScriptPath = "$ScriptRoot"
    }

    #3
    [Module]@{
        Enabled = $true
        Name = 'Network Bandwidth'
        RunIntervalMinutes = 60
        MinutesTillNextRun = $State | Where-Object {$_.Name -eq 'Network Bandwidth'} | Select-Object -ExpandProperty MinutesTillNextRun
        ScriptPath = "$ScriptRoot"
    }

    #4
    [Module]@{
        Enabled = $true
        Name = 'Administrator Monitor'
        RunIntervalMinutes = 10
        MinutesTillNextRun = $State | Where-Object {$_.Name -eq 'Administrator Monitor'} | Select-Object -ExpandProperty MinutesTillNextRun
        ScriptPath = "$ScriptRoot"
    }

    #5
    [Module]@{
        Enabled = $true
        Name = 'Cortex Endpoint Check'
        RunIntervalMinutes = (60 * 12)
        MinutesTillNextRun = $State | Where-Object {$_.Name -eq 'Cortex Endpoint Check'} | Select-Object -ExpandProperty MinutesTillNextRun
        ScriptPath = "$ScriptRoot"
    }

    #6
    [Module]@{
        Enabled = $true
        Name = 'Computer Environment Report'
        RunIntervalMinutes = (60 * 24)
        MinutesTillNextRun = $State | Where-Object {$_.Name -eq 'Computer Environment Report'} | Select-Object -ExpandProperty MinutesTillNextRun
        ScriptPath = "$ScriptRoot"
    }

)