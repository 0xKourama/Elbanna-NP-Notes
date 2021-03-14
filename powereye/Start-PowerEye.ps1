$ErrorActionPreference = 'stop'

$All_Computers       = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address -ne $null}

$Online              = Test-Connection -ComputerName $All_Computers -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0}

$Connected_Computers = Get-PSSession | Select-Object -ExpandProperty ComputerName

#find disconnected computers
$disconnected_computers = $Online | Where-Object {$Computers_in_session -notcontains $_}

#start sessions with them
New-PSSession -ComputerName $disconnected_computers

#grab all active sessions
$active_sessions = Get-PSSession | Where-Object {$_.Availability -eq 'Available' -and $_.State -eq 'Opened'}

$config_file_path = 'C:\users\admin\desktop\Config.csv'

#load config
$config = Import-Csv $config_file_path

$mail_settings = @{
    SMTPServer = $config.SMTPServer
    To         = $config.SenderMail
    From       = $config.RecepientMail
}

#Send-MailMessage @mail_settings -Subject -Body