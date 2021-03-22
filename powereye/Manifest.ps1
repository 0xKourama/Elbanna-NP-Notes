class Module {
    [string]$Name
    [int]$RunIntervalMinutes
    [int]$MinutesTillNextRun
    [string]$ScriptPath
    [string]$OutputPath
    [string]$MailSubject
    [bool]$Remote
    [bool]$Enabled
}

$General_SMTPServer = 'mail.worldposta.com'
$General_Sender     = 'PowerEye@roaya.co'
$General_Recipient  = 'mgabr@roaya.co'

$Modules = @(
    [Module]@{
        Name = 'SMB'
        RunIntervalMinutes = 2
        MinutesTillNextRun = 0
        ScriptPath = 'C:\users\GabrUrgent\powereye\SMB-Module.ps1'
        OutputPath = 'C:\Users\GabrUrgent\powereye\SMB-Report.csv'
        MailSubject = "PowerEye | SMB Module"
        Remote = $true
        Enabled = $false
    }
   [Module]@{
        Name = 'Network Bandwidth'
        RunIntervalMinutes = 60
        MinutesTillNextRun = 0
        ScriptPath = 'C:\users\GabrUrgent\powereye\NetworkBandwidth-Module.ps1'
        OutputPath = 'C:\Users\GabrUrgent\powereye\NetworkBandwidth-Module.csv'
        MailSubject = "PowerEye | Network Bandwidth Module"
        Remote = $false
        Enabled = $True
    }
   [Module]@{
        Name = 'Event Log'
        RunIntervalMinutes = 10
        MinutesTillNextRun = 0
        ScriptPath = 'C:\users\GabrUrgent\powereye\EventLog-Module.ps1'
        OutputPath = 'C:\Users\GabrUrgent\powereye\EventLog-Module.csv'
        MailSubject = "PowerEye | Event Log Module"
        Remote = $True
        Enabled = $false
    }
)