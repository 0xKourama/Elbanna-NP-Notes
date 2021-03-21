$ErrorActionPreference = 'Inquire'

[XML]$config = Get-Content 'C:\users\GabrUrgent\powereye\config.xml'

$General_SMTPServer = $config.Configuration.MailSettings.General.SMTPServer
$General_Sender     = $config.Configuration.MailSettings.General.Sender
$General_Recipient  = $config.Configuration.MailSettings.General.Recipient
$General_CC         = $config.Configuration.MailSettings.General.CC

class Module {
    [string]$Name
    [int]$RunInterval
    [int]$MinutesTillNextRun
    [string]$ScriptPath
    [string]$OutputPath
    [string]$MailSubject
    [bool]$Remote
    [bool]$Enabled
}

$Modules = @(
    [Module]@{
        Name = 'SMB'
        RunInterval = $config.Configuration.RunIntervals.SMBModule
        MinutesTillNextRun = 0
        ScriptPath = 'C:\users\GabrUrgent\powereye\SMB-Module.ps1'
        OutputPath = 'C:\Users\GabrUrgent\powereye\SMB-Report.csv'
        MailSubject = $config.Configuration.MailSettings.SMBModule.Subject
        Remote = $true
        Enabled = $false
    }
   [Module]@{
        Name = 'Network Bandwidth'
        RunInterval = $config.Configuration.RunIntervals.NetworkBandwidthModule
        MinutesTillNextRun = 0
        ScriptPath = 'C:\users\GabrUrgent\powereye\NetworkBandwidth-Module.ps1'
        OutputPath = 'C:\Users\GabrUrgent\powereye\NetworkBandwidth-Module.csv'
        MailSubject = $config.Configuration.MailSettings.NetworkBandwidthModule.Subject
        Remote = $false
        Enabled = $True
    }
)

$Original_Config_hash = Get-FileHash -Path C:\users\GabrUrgent\powereye\config.xml | Select-Object -ExpandProperty Hash

while($true){

    $current_config_hash = Get-FileHash -Path C:\users\GabrUrgent\powereye\config.xml | Select-Object -ExpandProperty Hash

    if($current_config_hash -ne $Original_Config_hash){
        Write-Host -ForegroundColor Yellow "[!] Config file changed. Updating the running configuration."
        [XML]$config = Get-Content 'C:\users\GabrUrgent\powereye\config.xml'
    }
    
    $Computers_with_ip = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address} | Select-Object -ExpandProperty Name
    $Online = Test-Connection -ComputerName $Computers_with_ip -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty address

    Write-Host -ForegroundColor Cyan "[*] Connectivity status: $($Online.count) computer(s) online"

    foreach($Module in ($Modules | Where-Object {$_.Enabled -eq $true} )){
        if($Module.MinutesTillNextRun -eq 0){
            if($Module.Remote -eq $true){

                Write-Host -ForegroundColor Cyan "[*] Control session status: Starting PSSessions"
                $sessions = New-PSSession -ComputerName $Online -ErrorAction SilentlyContinue | Where-Object {$_.state -eq 'opened' -and $_.Availability -eq 'Available'}
                Write-Host -ForegroundColor Green "[+] Control session status: $($Sessions.count) PSSessions are open and available"

                Write-Host -ForegroundColor Cyan "[*] Running $($Modules.Name)"

                $Result = Invoke-Command -Session $sessions -FilePath $Module.ScriptPath -ErrorAction SilentlyContinue |
                Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName |
                Sort-Object -Property PSComputerName            
            }
            elseif($Module.Remote -eq $false){
                $Result = & "$($Module.ScriptPath)"
            }


            $result | Export-Csv -NoTypeInformation $Module.OutputPath

            if($General_CC){
                Send-MailMessage -SmtpServer $General_SMTPServer `
                                 -From       $General_Sender     `
                                 -to         $General_Recipient  `
                                 -Subject    $Module.MailSubject `
                                 -CC         $General_CC         `
                                 -BodyAsHtml ($result | ConvertTo-Html | Out-String)
            }
            else{
                Send-MailMessage -SmtpServer $General_SMTPServer `
                                 -From       $General_Sender     `
                                 -to         $General_Recipient  `
                                 -Subject    $Module.MailSubject `
                                 -BodyAsHtml ($result | ConvertTo-Html | Out-String)            
            }

            Write-Host -ForegroundColor Green "[+] $($Module.Name) Ran successfully."
            Write-Host -ForegroundColor Green "[+] $($Module.Name) Results exported to $($module.OutputPath)."

            $Module.MinutesTillNextRun = $Module.RunInterval
        }
        else{
            Write-Host -ForegroundColor Cyan "[*] $($Module.MinutesTillNextRun) minute(s) till $($Module.Name) module's next run"
            $Module.MinutesTillNextRun--
        }
    }
    Get-PSSession | Remove-PSSession
    Write-Host -ForegroundColor Cyan "[*] Sleeping for a minute"
    Start-Sleep -Seconds 60
}