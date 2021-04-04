$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

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

    $MailBox_Servers = Get-MailboxServer "*MB*" | Select-Object -ExpandProperty Name

    $Result1 = @()
    $Result2 = @()

    Foreach($MailBox_Server in $MailBox_Servers){
        $Time_Ago = (Get-Date).AddMinutes(-10)
        $obj = @{} | Select-Object -Property Server, MinimumLatency`(MS`), MaximumLatency`(MS`), AverageLatency`(MS`)

        $Data = Get-MessageTrackingLog -Server $MailBox_Server -Start $Time_Ago -EventId Deliver -ResultSize Unlimited

        $Result2 += $Data | Where-Object {($_.MessageLatency -as [timespan]).TotalMilliSeconds -gt 300000} | 
                    Select-Object -Property messageid, sender, clienthostname, @{ Name = 'Latency(MS)'; Expression = {($_.MessageLatency -as [timespan]).TotalMilliSeconds} }

        $measurements = $Data | Select-Object -ExpandProperty MessageLatency | ForEach-Object {$_ -as [timespan]} | 
                               Select-Object -ExpandProperty TotalMilliSeconds | Measure-Object -Average -Maximum -Minimum
        $obj.Server = $MailBox_Server
        $obj."MinimumLatency(MS)" = $measurements | Select-Object -ExpandProperty Minimum
        $obj."MaximumLatency(MS)" = $measurements | Select-Object -ExpandProperty Maximum
        $obj."AverageLatency(MS)" = ($measurements | Select-Object -ExpandProperty Average) -as [int]
        $Result1 += $obj

        Clear-Variable -Name Data
    }

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
    background-color: #18368C;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header1 = @"
<h3>Exchange Mail Latency</h3>
"@

$Header2 = @"
<h3>Emails exceeding 5 minutes delay</h3>
"@

    $MailSettings = @{
        SMTPserver = '192.168.3.202'
        From       = 'MailLatency@roaya.co'
        To         = 'operation@roaya.co'
        Subject    = 'PowerEye | Mail Latency Module'
    }

    Write-Host -ForegroundColor Green "[+] Sending mail alert"
    $res1HTML = $result1 | Where-Object {$_.'MinimumLatency(MS)' -and $_.'MaximumLatency(MS)'} | ConvertTo-Html -Fragment | Out-String
    $res2HTML = $result2 | ConvertTo-Html -Fragment | Out-String
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header1 $res1HTML $Header2 $res2HTML"

    Start-Sleep -Seconds 600
    [GC]::Collect()
}