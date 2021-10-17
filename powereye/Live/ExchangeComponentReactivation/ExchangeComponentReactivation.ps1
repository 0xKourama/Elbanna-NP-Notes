Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Exchange_Servers = @(
    'EU1MB9901.Roaya.loc'
    'EU1MB9902.Roaya.loc'
    'EU1MB9903.Roaya.loc'
)


$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$UserCredential    = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

foreach($Exchange_Server in $Exchange_Servers){
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange `
                             -ConnectionUri "http://$Exchange_Server/powershell" `
                             -Authentication Kerberos `
                             -Credential $UserCredential

    Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null
    if($? -eq $true){
        Write-Host -ForegroundColor green "[+] Session established with $Exchange_Server"
        break
    }
}


$Output = @()
$inactive_components = (Get-ExchangeServer|?{$_.name -like 'eu1fe*'}).Name | Get-ServerComponentState | Where-Object {$_.State -ne 'active'}

if($inactive_components){
    ForEach($inactive_component in $inactive_components) {
        Set-ServerComponentState -Identity $inactive_component.ServerFQDN -Component $inactive_component.Component -State Active -Requester Functional
        if($?){
            $Output += [PSCustomObject][Ordered]@{
                Server             = $inactive_component.ServerFQDN
                Component          = $inactive_component.Component
                ReactivationStatus = 'Success'
                Error              = 'N/A'
            }
        }
        else{
            $Output += [PSCustomObject][Ordered]@{
                Server             = $inactive_component.ServerFQDN
                Component          = $inactive_component.Component
                ReactivationStatus = 'Failure'
                Error              = $Error[0]
            }
        }
    }
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Output | Sort-Object -Property Server | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Host -ForegroundColor Green '[+] All exchange components are active'
}
Remove-PSSession $Session