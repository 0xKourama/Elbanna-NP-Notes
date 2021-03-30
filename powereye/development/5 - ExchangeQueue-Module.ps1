$Exchange_Servers = @(
    'frank-fem-f01.roaya.loc:8080'
    'frank-fem-f02.roaya.loc:8080'
    'frank-fem-f03.roaya.loc:8080'
    'frank-fem-f04.roaya.loc:8080'
)

$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$UserCredential = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

while($true){

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

    Write-Host -ForegroundColor Cyan "[*] Running module at $(Get-Date)"

    Clear-Variable res, resHTML -ErrorAction SilentlyContinue

    $Required_properties = @(
        'Identity'
        'Status'
        'NextHopDomain'
        'MessageCount'
        'LastError'
    )

    $Message_Count_threshold = 25

    $res = Get-MailboxServer | ForEach-Object {
        Get-Queue -Server $_.name |
        Where-Object {
            $_.MessageCount -gt $Message_Count_threshold -and `
            $_.NextHopDomain -notlike "*frank contoso.com*" -and `
            $_.DeliveryType -notlike "*ShadowRedundancy*"
        }
    } | Select-Object -Property $Required_properties

    Remove-PSSession -Session $Session

    if($res){
        Write-Host -ForegroundColor Yellow "[!] Queue Conditions met. Sending mail alert"
        $resHTML = $res | ConvertTo-Html | Out-String
        $Header = @"
<style>
th, td {
    border: 2px solid black;
    text-align: center;
}
table{
    border-collapse: collapse;
    border: 2px solid black;
    width: 100%;
}
h3{
    color: white;
    background-color: #FF0000;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
<h3>Exchange Queue Warning:</h3>
"@
        Send-MailMessage -SmtpServer 192.168.3.202 `
                         -From ExchangeQueue@roaya.co `
                         -To Operation@roaya.co `
                         -Subject 'Exchange Queue Warning' `
                         -BodyAsHtml "$Header $resHTML"
    }
    else{
        Write-Host -ForegroundColor Green "[+] Queue Conditions not met. No mail sent"
    }

    Start-Sleep -Seconds 300
}