Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$script = {
    if($env:COMPUTERNAME -like 'EU1MB*'){
        $Services_to_Check = @(
            'IISAdmin'
            'MSExchangeADTopology'
            'MSExchangeDelivery'
            'MSExchangeEdgeSync'
            'MSExchangeIMAP4'
            'MSExchangeIS'
            'MSExchangeMailboxAssistants'
            'MSExchangeMailboxReplication'
            'MSExchangeRepl'
            'MSExchangeRPC'
            'MSExchangeServiceHost'
            'MSExchangeSubmission'
            'MSExchangeThrottling'
            'MSExchangeTransport'
            'MSExchangeTransportLogSearch'
            'W3Svc'
            'WinRM'
        )
    }
    elseif($env:COMPUTERNAME -like 'EU1FE9*'){
        $Services_to_Check = @(
            'IISAdmin'
            'MSExchangeADTopology'
            'MSExchangeDelivery'
            'MSExchangeEdgeSync'
            'MSExchangeIMAP4'
            'MSExchangeIS'
            'MSExchangeMailboxAssistants'
            'MSExchangeMailboxReplication'
            'MSExchangeRepl'
            'MSExchangeRPC'
            'MSExchangeServiceHost'
            'MSExchangeSubmission'
            'MSExchangeThrottling'
            'MSExchangeTransport'
            'MSExchangeTransportLogSearch'
            'W3Svc'
            'WinRM'        
        )
    }
    elseif($env:COMPUTERNAME -like 'EU1FE3*'){
        $Services_to_Check = @(
            'IISAdmin'
            'W3Svc'
            'WinRM'
            'MSExchangeADTopology'
            'MSExchangeDiagnostics'
            'MSExchangeFrontEndTransport'
            'MSExchangeHM'
            'MSExchangeIMAP4'
            'MSExchangeServiceHost'
            'MSExchangeUMCR'
        )
    }
    Get-Service | Where-Object {$Services_to_Check -contains $_.Name -and $_.Status -ne 'Running'} | Start-Service -PassThru
}

$Reactivated_Services = Invoke-Command -ComputerName (Get-ADComputer -Filter {name -like 'eu1fe*' -or name -like 'eu1mb*'}).Name -ScriptBlock $Script -ArgumentList $Services_to_Check |
                        Select-Object -Property @{n='Server Name'; e={$_.PSComputerName}}, @{n='Service Name'; e={$_.Name}}, @{n='Reactivation Status';e={if($_.Status -eq 'Running'){'Success'}else{'Failure'}}}

if($Reactivated_Services){
    Write-Host '[!] Stopped services were found. Sending mail..'
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Reactivated_Services | sort -Property 'Server Name' | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Host '[+] All services were running.'
}