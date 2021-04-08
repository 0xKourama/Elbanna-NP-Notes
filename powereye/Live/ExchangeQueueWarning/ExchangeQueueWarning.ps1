Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Message_Count_threshold = 25

$Exchange_Servers = @(
    'frank-fem-f01.roaya.loc:8080'
    'frank-fem-f02.roaya.loc:8080'
    'frank-fem-f03.roaya.loc:8080'
    'frank-fem-f04.roaya.loc:8080'
)

$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[SecureString]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[PSCredential]$UserCredential    = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

#region test session
$present_session = Get-PSSession

if(!$present_session -or ($present_session.Availability -ne 'Available') -or ($present_session.State -ne 'Opened')){
    try{Remove-PSSession $present_session}
    catch{}
    foreach($Exchange_Server in $Exchange_Servers){
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange `
                                 -ConnectionUri "http://$Exchange_Server/PowerShell/" `
                                 -Authentication Kerberos `
                                 -Credential $UserCredential

        Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null
        if($? -eq $true){
            Write-Host -ForegroundColor green "[+] Session established with $Exchange_Server"
            break
        }
    }
}
#endregion

#properties for queue
$Required_properties = @(
    'Identity'
    'Status'
    'NextHopDomain'
    'MessageCount'
    'DeliveryType'
    'LastError'
)

#query
$Result = Get-MailboxServer | ForEach-Object {Get-Queue -Server $_.name | Select-Object -Property $Required_properties} | 
          Where-Object {
                    $_.MessageCount -gt $Message_Count_threshold    -and `
                    $_.NextHopDomain -notlike "*frank contoso.com*" -and `
                    $_.DeliveryType -notlike "*ShadowRedundancy*"
          } | Sort-Object -Property MessageCount -Descending

if($Result){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html | Out-String)"
}