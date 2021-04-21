Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$FrontEndServers = @(
    'EU1MB9901.Roaya.loc'
    'EU1MB9902.Roaya.loc'
    'EU1MB9903.Roaya.loc'
)

$Result = @()

$Script = {
    Write-Host -ForegroundColor Cyan "[*] Working on $env:COMPUTERNAME"
    $Services = 'MSExchangeFrontEndTransport', 'MSExchangeTransport'
    foreach($service in $Services){
        do{
            Write-Host -ForegroundColor Cyan "[*] Restarting $service"
            Restart-Service -Name $Service
        }
        while((Get-Service -Name $Service).Status -ne 'Running')
        Write-Host -ForegroundColor Green "[+] $Service restarted successfully"
    }
    Start-Sleep -Seconds 30
    Get-Service $Services
}

$Result += $FrontEndServers | ForEach-Object{ Invoke-Command -ComputerName $_ -ScriptBlock $Script } | 
           Select-Object -Property @{Name='ComputerName'; Expression={$_.PSComputerName}},@{Name='Service'; Expression={$_.Name}}, Status |
           Sort-Object ComputerName

Write-Output $Result

Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html)"