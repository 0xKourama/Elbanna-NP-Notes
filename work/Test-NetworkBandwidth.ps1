Param(
    $Executable_location,
    $OutputFile
)

$ErrorActionPreference = 'Stop'

$ADComputers = Get-ADComputer -Filter * -Properties IPV4Address,DNSHostName | Where-Object {$_.IPV4Address} | Select-Object -ExpandProperty DNSHostName

$Online_Hosts = Test-Connection -ComputerName $ADComputers -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address

$Online_Hosts | ForEach-Object {
    if((Test-Path "\\$_\c$\Windows\Temp") -eq $false){
        Copy-Item -Path $Executable_location -Destination "\\$_\c$\Windows\Temp" -PassThru
    }
}

$Listener_Verbose_Code = {
    $OutFileHost = $args[0]
    $OutputFile = $args[1] -replace ':','$'
    Write-Host "[*] Listener started on $env:COMPUTERNAME" -ForegroundColor Cyan
    Write-Host "[*] writing output to \\$OutFileHost\$OutputFile" -ForegroundColor Cyan
}

$Listener_Code = {
    C:\Windows\Temp\iperf3.exe -s # >> \\$OutFileHost\$OutputFile
}

$Connector_Code = {
    $Server = $args[0]
    Write-Host "[*] Testing bandwidth to $Server from $env:COMPUTERNAME" -ForegroundColor Cyan

    C:\Windows\Temp\iperf3.exe -c $Server |
    Select-Object -Skip 3 -First 10 |
    Select-String -Pattern '(\d{1,3}.\d) MBytes' -AllMatches |
    Select-Object -ExpandProperty matches |
    Select-Object -ExpandProperty groups |
    Where-Object {$_.name -eq 1} |
    Select-Object -ExpandProperty value |
    Measure-Object -Average |
    Select-Object -ExpandProperty average

    Write-Host "[+] Finished testing to $Server from $env:COMPUTERNAME" -ForegroundColor Green
}

foreach($Host1 in $Online_Hosts){
    
    $Listener_Session = New-PSSession -ComputerName $Host1

    Invoke-Command -Session $Listener_Session -ScriptBlock $Listener_Verbose_Code -ArgumentList $env:COMPUTERNAME, $OutputFile

    $Listener_Job = Invoke-Command -Session $Listener_Session -ScriptBlock $Listener_Code -AsJob

    Start-Sleep -Seconds 1
    
    foreach($Host2 in $Online_Hosts){
        if($Host2 -ne $Host1){
            $result = Invoke-Command -ComputerName $Host2 -ScriptBlock $Connector_Code -ArgumentList $Host1
        }
    }

    Write-Host "[*] Stopping Listener on $Host1" -ForegroundColor Cyan
    $Listener_Job | Stop-Job
    $Listener_Job | Remove-Job

    $Listener_Session | Remove-PSSession
    Write-Host "[+] Listener stopped on $Host1" -ForegroundColor Green
}