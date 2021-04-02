$ProgressPreference = 'SilentlyContinue'

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

    Write-Host -ForegroundColor Cyan "[*] Running module at $(Get-Date)"

    Clear-Variable res, resHTML -ErrorAction SilentlyContinue

    $Required_properties = @(
        'Identity'
        'Status'
        'NextHopDomain'
        'MessageCount'
        'DeliveryType'
        'LastError'
    )

    $Message_Count_threshold = 25

    $res = Get-MailboxServer | ForEach-Object { Get-Queue -Server $_.name | Select-Object -Property $Required_properties }

    $res_Alert = $res | Where-Object {
            $_.MessageCount -gt $Message_Count_threshold -and `
            $_.NextHopDomain -notlike "*frank contoso.com*" -and `
            $_.DeliveryType -notlike "*ShadowRedundancy*"
    } | Sort-Object -Property MessageCount -Descending

    Write-Output $Res | Sort-Object -Property MessageCount -Descending | Select-Object -First 20 | Format-Table -AutoSize

$Style = @"
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
"@

$Header = @"
<h3>Exchange Queue Warning:</h3>
"@

    $MailSettings = @{
        SMTPserver = '192.168.3.202'
        From       = 'ExchangeQueue@roaya.co'
        To         = 'operation@roaya.co'
        Subject    = 'PowerEye | Exchange Queue Warning'
    }

    if($res_Alert){
        Write-Host -ForegroundColor Yellow "[!] Queue Conditions met. Sending mail alert"
        $resHTML = $res_Alert | ConvertTo-Html | Out-String
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $resHTML"

    }
    else{
        Write-Host -ForegroundColor Green "[+] Queue Conditions not met. No mail sent"
    }
    Write-Host -ForegroundColor Cyan '[*] Sleeping for 10 minutes'
    Start-Sleep -Seconds (60 * 10)
    [GC]::Collect()
}