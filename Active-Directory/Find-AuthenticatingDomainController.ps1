$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<EXCH_SERVER_FQDN>/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking
$Exchange_Servers = Invoke-Command $Session -ScriptBlock {Get-ExchangeServer | Select-Object -ExpandProperty Name}
$Online_Exchange_Servers = Test-Connection -ComputerName $Exchange_Servers -Count 1 | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address
$Online_Exchange_Servers | ForEach-Object { Get-WmiObject -Class win32_ntdomain -Filter "DomainName = 'Roaya'" -ComputerName $_ | Select-Object -Property PSCOmputername,DomainControllerName}