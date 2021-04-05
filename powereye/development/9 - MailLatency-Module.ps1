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

    $MailBox_Servers = Get-MailboxServer "*MB*" | Select-Object -ExpandProperty Name

    $InternalMailLatency = @()
    $InternalMailsExceedingDelayThreshold = @()

    $ExternalMailLatency = @()
    $ExternalMailsExceedingDelayThreshold = @()

    $ExternalSenderList = @(
        '.*@gmail.com'
        '.*@live.com'
        '.*@outlook.com'
        '.*@hotmail.com'
        '.*@yahoo.com'
    ) -join '|'

    $LatencyThresholdSeconds = 120

    $VariablesToClear = @(
        'Data'
        'InternalObject'
        'InternalData'
        'InternalMeasurements'
        'InternalMailsExceedingDelayThreshold'
        'ExternalObject'
        'ExternalData'
        'ExternalMeasurements'
        'ExternalMailsExceedingDelayThreshold'
    )

    $PropertyList = @(
        'Server'
        'MinimumLatency(S)'
        'MaximumLatency(S)'
        'AverageLatency(S)'
    )

    Foreach($MailBox_Server in $MailBox_Servers){

        $Time_Ago = (Get-Date).AddMinutes(-10)

        $InternalObject = @{} | Select-Object -Property $PropertyList
        $ExternalObject = @{} | Select-Object -Property $PropertyList

        $Data = Get-MessageTrackingLog -Server $MailBox_Server -Start $Time_Ago -EventId Deliver -ResultSize Unlimited

        $InternalData = $Data | Where-Object {$_.Directionality -eq "Originating"}

        $ExternalData = $Data | Where-Object {$_.Sender -match $ExternalSenderList}

        $InternalMeasurements = $InternalData | Select-Object -ExpandProperty MessageLatency | ForEach-Object {$_ -as [timespan]} | 
                               Select-Object -ExpandProperty TotalSeconds | Measure-Object -Average -Maximum -Minimum

        $ExternalMeasurements = $ExternalData | Select-Object -ExpandProperty MessageLatency | ForEach-Object {$_ -as [timespan]} | 
                               Select-Object -ExpandProperty TotalSeconds | Measure-Object -Average -Maximum -Minimum

        $InternalObject.Server = $MailBox_Server
        $InternalObject."MinimumLatency(S)" = $InternalMeasurements | Select-Object -ExpandProperty Minimum
        $InternalObject."MaximumLatency(S)" = $InternalMeasurements | Select-Object -ExpandProperty Maximum
        $InternalObject."AverageLatency(S)" = [math]::Round(($InternalMeasurements.Average),2)
        $InternalMailLatency += $InternalObject

        $ExternalObject.Server = $MailBox_Server
        $ExternalObject."MinimumLatency(S)" = $ExternalMeasurements | Select-Object -ExpandProperty Minimum
        $ExternalObject."MaximumLatency(S)" = $ExternalMeasurements | Select-Object -ExpandProperty Maximum
        $ExternalObject."AverageLatency(S)" = [math]::Round(($ExternalMeasurements.Average),2)
        $ExternalMailLatency += $ExternalObject

        $InternalMailsExceedingDelayThreshold += $InternalData | Where-Object {($_.MessageLatency -as [timespan]).TotalSeconds -gt $LatencyThresholdSeconds} | 
                    Select-Object -Property messageid, sender, clienthostname, @{ Name = 'Latency(S)'; Expression = {($_.MessageLatency -as [timespan]).TotalSeconds} }

        $ExternalMailsExceedingDelayThreshold += $ExternalData | Where-Object {($_.MessageLatency -as [timespan]).TotalSeconds -gt $LatencyThresholdSeconds} | 
                    Select-Object -Property messageid, sender, clienthostname, @{ Name = 'Latency(S)'; Expression = {($_.MessageLatency -as [timespan]).TotalSeconds} }

        Clear-Variable $VariablesToClear
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
    padding: 3px;
    background-color: #210b9e;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header1 = @"
<h3>Internal Mail Latency</h3>
"@

$Header2 = @"
<h3>Internal mails exceeding $($LatencyThresholdSeconds/60) minutes delay</h3>
"@

$Header3 = @"
<h3>External Mail Latency</h3>
"@

$Header4 = @"
<h3>External mmails exceeding $($LatencyThresholdSeconds/60) minutes delay</h3>
"@

    $MailSettings = @{
        SMTPserver = '192.168.3.202'
        From       = 'MailLatency@roaya.co'
        To         = 'operation@roaya.co'
        #To         = 'mgabr@roaya.co'
        Subject    = 'Mail Latency Module'
    }

    $InternalResult1HTML = $InternalMailLatency | Where-Object {$_.'MinimumLatency(S)' -and $_.'MaximumLatency(S)'} | ConvertTo-Html -Fragment | Out-String
    $InternalResult2HTML = $InternalMailsExceedingDelayThreshold | ConvertTo-Html -Fragment | Out-String
    if(!$InternalMailsExceedingDelayThreshold){$Header2 = $null}

    $ExternalResult1HTML = $ExternalMailLatency | Where-Object {$_.'MinimumLatency(S)' -and $_.'MaximumLatency(S)'} | ConvertTo-Html -Fragment | Out-String
    $ExternalResult2HTML = $ExternalMailsExceedingDelayThreshold | ConvertTo-Html -Fragment | Out-String
    if(!$ExternalMailsExceedingDelayThreshold){$Header4 = $null}

    if($ExternalMailsExceedingDelayThreshold -or $InternalMailsExceedingDelayThreshold){
        Write-Host -ForegroundColor Yellow "[!] Latency threshold $($LatencyThresholdSeconds) seconds exceeded. Sending mail alert"
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header1 $InternalResult1HTML $Header2 $InternalResult2HTML $Header3 $ExternalResult1HTML $Header4 $ExternalResult2HTML"
    }
    else{
        Write-Host -ForegroundColor Green "[+] Latency threshold $($LatencyThresholdSeconds) seconds not exceeded"
    }

    Start-Sleep -Seconds 600
    [GC]::Collect()
}