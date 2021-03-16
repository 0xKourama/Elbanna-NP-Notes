$ErrorActionPreference = 'stop'

$All_Computers = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address -ne $null}

$Online        = Test-Connection -ComputerName $All_Computers -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0}

$Sessions      = New-PSSession

#find disconnected computers
$disconnected_computers = $Online | Where-Object {$Computers_in_session -notcontains $_}

#grab all active sessions
$active_sessions = Get-PSSession | Where-Object {$_.Availability -eq 'Available' -and $_.State -eq 'Opened'}

$mail_settings = @{
    SMTPServer = $config.MailSettings.SMTPServer
    To         = $config.MailSettings.SenderMail
    From       = $config.MailSettings.RecepientMail
}

$SMB_Module = {
    $Properties = @(
        'Name'
        'Path'
        'Description'
    )
    Get-SmbShare | Select-Object -Property $Properties
}

[XML]$config = Get-Content ''

class Module {
    [string]$Name
    [int]$Pollinterval
    [int]$MinutesTillNextRun
    [scriptblock]$ScriptBlock
}

$Modules = @(
    [PollInterval]@{
        ModuleName = 'SMB'
        PollInterval = $config.PollIntervals.SMBModule
    }
)

while($true){

    Invoke-Command -Session $active_sessions -ScriptBlock $SMB_Module   

    Start-Sleep -Seconds 60
    foreach($Pollinterval in $Pollintervals){
        $Pollinterval.MinutesTillNextRun--
    }
}