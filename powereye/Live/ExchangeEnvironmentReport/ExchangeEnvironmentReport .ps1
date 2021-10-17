$Exchange_Server = 'EU1MB9901.Roaya.loc'
$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[SecureString]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[PSCredential]$UserCredential    = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
                            -ConnectionUri "http://$Exchange_Server/PowerShell/" `
                            -Authentication Kerberos `
                            -Credential $UserCredential

Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null

.\Get-ExchangeEnvironmentReport.ps1

Remove-PSSession -Session $Session