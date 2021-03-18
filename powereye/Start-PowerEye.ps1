$ErrorActionPreference = 'Inquire'

[XML]$config = Get-Content 'config.xml'

$All_Computers = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address -ne $null}

$Online        = Test-Connection -ComputerName $All_Computers -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0}

$Sessions      = New-PSSession -ErrorAction SilentlyContinue

#find disconnected computers
$disconnected_computers = $Online | Where-Object {$Computers_in_session -notcontains $_}

#grab all active sessions
$active_sessions = Get-PSSession | Where-Object {$_.Availability -eq 'Available' -and $_.State -eq 'Opened'}

$mail_settings = @{
    SMTPServer = $config.MailSettings.SMTPServer
    To         = $config.MailSettings.SenderMail
    From       = $config.MailSettings.RecepientMail
}

class Module {
    [string]$Name
    [int]$Pollinterval
    [int]$MinutesTillNextRun
    [string]$ScriptPath
}

$Modules = @(
    [PollInterval]@{
        ModuleName = 'SMB'
        PollInterval = $config.PollIntervals.SMBModule
        MinutesTillNextRun = $config.PollIntervals.SMBModule
        ScriptPath = ''
    }
)

while($true){
    foreach($Module in $Modules){
        Write-Host -ForegroundColor Cyan "[*] Running $($Modules.Name)"
        Invoke-Command -Session $active_sessions -FilePath $Module.ScriptPath

        Start-Sleep -Seconds 60
        foreach($Pollinterval in $Pollintervals){
            $Pollinterval.MinutesTillNextRun--
        }    
    }
}