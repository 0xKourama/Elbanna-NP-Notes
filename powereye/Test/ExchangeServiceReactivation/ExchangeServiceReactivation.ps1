Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$script = {
    $Services_to_Check = @(
        'MSExchangeImap4'
        'MSExchangeImap4BE'
    )
    Get-Service | Where-Object {$Services_to_Check -contains $_.Name -and $_.Status -ne 'Running'} | Start-Service -PassThru
}

$Reactivated_Services = Invoke-Command -ComputerName (Get-ADComputer -Filter {name -like 'eu1fe*' -or name -like 'eu1mb*'}).Name `
                                       -ScriptBlock $Script |
                        Select-Object -Property @{n='Server Name'; e={$_.PSComputerName}}, @{n='Service Name'; e={$_.Name}}, @{n='Reactivation Status';e={if($_.Status -eq 'Running'){'Success'}else{'Failure'}}}

if($Reactivated_Services){
    Write-Host '[!] Stopped services were found. Sending mail..'
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Reactivated_Services | sort -Property 'Server Name' | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Host '[+] All services were running.'
}