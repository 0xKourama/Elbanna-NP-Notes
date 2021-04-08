Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

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

$LatencyThresholdSeconds = 120

$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$UserCredential = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

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

$InternalMailLatency = @()
$InternalMailsExceedingDelayThreshold = @()

$ExternalMailLatency = @()
$ExternalMailsExceedingDelayThreshold = @()

#region loop over mailbox servers to collect data
Foreach($MailBox_Server in (Get-MailboxServer "*MB*" ).Name){

    $Time_Ago = (Get-Date).AddMinutes(-10)
    
    #get logs from 10 minutes ago till now
    $Data = Get-MessageTrackingLog -Server $MailBox_Server -Start $Time_Ago -EventId Deliver -ResultSize Unlimited

    #if logs are present, get internal logs and the ones sent from the configured sender list
    if($Data){
        $InternalData = $Data | Where-Object {$_.Directionality -eq "Originating"}
        $ExternalData = $Data | Where-Object {$_.Sender -match $ExternalSenderList}

        #getting internal and external measurements
        $InternalMeasurements = $InternalData.MessageLatency | ForEach-Object {($_ -as [timespan]).TotalSeconds} | Measure-Object -Minimum -Maximum -Average
        $ExternalMeasurements = $ExternalData.MessageLatency | ForEach-Object {($_ -as [timespan]).TotalSeconds} | Measure-Object -Minimum -Maximum -Average

        $InternalMailLatency += [pscustomobject][ordered]@{
            Server              = $MailBox_Server
            'MinimumLatency(S)' = [math]::Round(($InternalMeasurements.Minimum),2)
            'MaximumLatency(S)' = [math]::Round(($InternalMeasurements.Maximum),2)
            'AverageLatency(S)' = [math]::Round(($InternalMeasurements.Average),2)
        }

        $ExternalMailLatency += [pscustomobject][ordered]@{
            Server              = $MailBox_Server
            'MinimumLatency(S)' = [math]::Round(($ExternalMeasurements.Minimum),2)
            'MaximumLatency(S)' = [math]::Round(($ExternalMeasurements.Maximum),2)
            'AverageLatency(S)' = [math]::Round(($ExternalMeasurements.Average),2)            
        }

        #getting mails that exceed the configured threshold
        $InternalMailsExceedingDelayThreshold += $InternalData | Where-Object {($_.MessageLatency -as [timespan]).TotalSeconds -gt $LatencyThresholdSeconds} | 
                    Select-Object -Property MessageID,
                                            Sender,
                                            ClientHostName,
                                            @{ Name = 'Latency(S)'; Expression = {($_.MessageLatency -as [timespan]).TotalSeconds} }

        $ExternalMailsExceedingDelayThreshold += $ExternalData | Where-Object {($_.MessageLatency -as [timespan]).TotalSeconds -gt $LatencyThresholdSeconds} | 
                    Select-Object -Property MessageID,
                                            Sender,
                                            ClientHostName,
                                            @{ Name = 'Latency(S)'; Expression = {($_.MessageLatency -as [timespan]).TotalSeconds} }    
    }
}
#endregion

#region adding results to HTML
$InternalResult1HTML = $InternalMailLatency | ConvertTo-Html -Fragment | Out-String
if($InternalMailsExceedingDelayThreshold){
    $Header2 = "<h3>Internal mails exceeding $($LatencyThresholdSeconds/60) minutes delay</h3>"
    $InternalResult2HTML = $InternalMailsExceedingDelayThreshold | ConvertTo-Html -Fragment | Out-String
}

$ExternalResult1HTML = $ExternalMailLatency | ConvertTo-Html -Fragment | Out-String
if($ExternalMailsExceedingDelayThreshold){
    $Header4 = "<h3>External mails exceeding $($LatencyThresholdSeconds/60) minutes delay</h3>"
    $ExternalResult2HTML = $ExternalMailsExceedingDelayThreshold | ConvertTo-Html -Fragment | Out-String
}
#endregion

#send mails only if the configured threshold has been exceed. Either internally or externally
if($ExternalMailsExceedingDelayThreshold -or $InternalMailsExceedingDelayThreshold){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header1 $InternalResult1HTML $Header2 $InternalResult2HTML $Header3 $ExternalResult1HTML $Header4 $ExternalResult2HTML"
}