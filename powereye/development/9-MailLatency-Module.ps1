$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
$SleepIntervalSeconds = 600
$LatencyThresholdSeconds = 120

$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$UserCredential = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'MailLatency@roaya.co'
    #To         = 'operation@roaya.co'
    To         = 'mgabr@roaya.co'
    Subject    = 'Mail Latency Module'
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

$Header1 = "<h3>Internal Mail Latency</h3>"
$Header3 = "<h3>External Mail Latency</h3>"

$Exchange_Servers = @(
    'frank-fem-f01.roaya.loc:8080'
    'frank-fem-f02.roaya.loc:8080'
    'frank-fem-f03.roaya.loc:8080'
    'frank-fem-f04.roaya.loc:8080'
)

$ExternalSenderList = @(
    '.*@gmail.com'
    '.*@live.com'
    '.*@outlook.com'
    '.*@hotmail.com'
    '.*@yahoo.com'
) -join '|'

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

while($true){

    #region session check
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

    Write-Host -ForegroundColor Cyan "[*] Running module at $(Get-Date)"

    $MailBox_Servers = (Get-MailboxServer "*MB*" ).Name

    $InternalMailLatency = @()
    $InternalMailsExceedingDelayThreshold = @()

    $ExternalMailLatency = @()
    $ExternalMailsExceedingDelayThreshold = @()

    Foreach($MailBox_Server in $MailBox_Servers){

        $Time_Ago = (Get-Date).AddMinutes(-10)

        $Data = Get-MessageTrackingLog -Server $MailBox_Server -Start $Time_Ago -EventId Deliver -ResultSize Unlimited

        $InternalData = $Data | Where-Object {$_.Directionality -eq "Originating"}
        $ExternalData = $Data | Where-Object {$_.Sender -match $ExternalSenderList}

        $InternalMeasurements = $InternalData.MessageLatency | ForEach-Object {($_ -as [timespan]).TotalSeconds} | Measure-Object -Minimum -Maximum -Average
        $ExternalMeasurements = $ExternalData.MessageLatency | ForEach-Object {($_ -as [timespan]).TotalSeconds} | Measure-Object -Minimum -Maximum -Average

        $InternalObject = [pscustomobject][ordered]@{
            Server              = $MailBox_Server
            'MinimumLatency(S)' = $InternalMeasurements.Minimum
            'MaximumLatency(S)' = $InternalMeasurements.Maximum
            'AverageLatency(S)' = [math]::Round(($InternalMeasurements.Average),2)
        }

        $InternalMailLatency += $InternalObject

        $ExternalObject = [pscustomobject][ordered]@{
            Server              = $MailBox_Server
            'MinimumLatency(S)' = $ExternalMeasurements.Minimum
            'MaximumLatency(S)' = $ExternalMeasurements.Maximum
            'AverageLatency(S)' = [math]::Round(($ExternalMeasurements.Average),2)            
        }

        $ExternalMailLatency += $ExternalObject

        $InternalMailsExceedingDelayThreshold += $InternalData | Where-Object {($_.MessageLatency -as [timespan]).TotalSeconds -gt $LatencyThresholdSeconds} | 
                    Select-Object -Property messageid,
                                            sender,
                                            clienthostname,
                                            @{ Name = 'Latency(S)'; Expression = {($_.MessageLatency -as [timespan]).TotalSeconds} }

        $ExternalMailsExceedingDelayThreshold += $ExternalData | Where-Object {($_.MessageLatency -as [timespan]).TotalSeconds -gt $LatencyThresholdSeconds} | 
                    Select-Object -Property messageid,
                                            sender,
                                            clienthostname,
                                            @{ Name = 'Latency(S)'; Expression = {($_.MessageLatency -as [timespan]).TotalSeconds} }
    }

    $InternalResult1HTML = $InternalMailLatency | Where-Object {$_.'MinimumLatency(S)' -and $_.'MaximumLatency(S)'} | ConvertTo-Html -Fragment | Out-String
    if($InternalMailsExceedingDelayThreshold){
        $InternalResult2HTML = $InternalMailsExceedingDelayThreshold | ConvertTo-Html -Fragment | Out-String
        $Header2 = "<h3>Internal mails exceeding $($LatencyThresholdSeconds/60) minutes delay</h3>"
    }

    $ExternalResult1HTML = $ExternalMailLatency | Where-Object {$_.'MinimumLatency(S)' -and $_.'MaximumLatency(S)'} | ConvertTo-Html -Fragment | Out-String
    if($ExternalMailsExceedingDelayThreshold){
        $ExternalResult2HTML = $ExternalMailsExceedingDelayThreshold | ConvertTo-Html -Fragment | Out-String
        $Header4 = "<h3>External mails exceeding $($LatencyThresholdSeconds/60) minutes delay</h3>"
    }

    if($ExternalMailsExceedingDelayThreshold -or $InternalMailsExceedingDelayThreshold){
        Write-Host -ForegroundColor Yellow "[!] Latency threshold $($LatencyThresholdSeconds) seconds exceeded. Sending mail alert"
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header1 $InternalResult1HTML $Header2 $InternalResult2HTML $Header3 $ExternalResult1HTML $Header4 $ExternalResult2HTML"
    }
    else{
        Write-Host -ForegroundColor Green "[+] Latency threshold $($LatencyThresholdSeconds) seconds not exceeded"
    }

    Clear-Variable -Name $VariablesToClear
    [GC]::Collect()

    Write-Host -ForegroundColor Cyan "[*] Sleeping for $SleepIntervalSeconds seconds."
    Start-Sleep -Seconds $SleepIntervalSeconds
}