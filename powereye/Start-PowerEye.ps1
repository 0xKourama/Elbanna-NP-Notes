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

$SMB_Mon_Block = {
    [xml]$Config = Get-Content ''
    $Poll_Interval = $Config.PollIntervals.SMBModule
    $active_sessions = Get-PSSession | Where-Object {$_.Availability -eq 'Available' -and $_.State -eq 'Opened'}
    $Script = {
        $Properties = @(
            'Name'
            'Path'
            'Description'
        )
        Get-SmbShare | Select-Object -Property $Properties
    }
    Invoke-Command -Session $active_sessions -ScriptBlock $Script | Export-Csv ''
    Start-Sleep -Seconds $Poll_Interval
}

[XML]$config = Get-Content ''

foreach($Enabled_Module in $config.EnabledModules){
    switch($Enabled_Module){
        'SMBMon'{Start-Job -ScriptBlock $SMB_Mon_Block}
        'EventMon'{Start-Job -ScriptBlock $Event_Mon_Block}
        'ADMon'{Start-Job -ScriptBlock $AD_Mon_Block}
        'PasswordMon'{Start-Job -ScriptBlock $Password_Mon_Block}
    }
}