Param(
    $NodeFile,
    $OutputFile
)

$ErrorActionPreference = 'Stop'
$Nodes = Get-Content $NodeFile

if(!$OutputFile){
    Write-Host '[!] Make sure you provide the output file' -ForegroundColor Yellow
}
elseif($Nodes.Count -lt 2){
    Write-Host '[!] Provide at least two nodes' -ForegroundColor Yellow
}
else{
    $Servers = $Nodes

    $Listener_Verbose_Code = {
        $OutFileHost = $args[0]
        $OutputFile = $args[1] -replace ':','$'
        Write-Host "[*] Listener started on $env:COMPUTERNAME" -ForegroundColor Cyan
        Write-Host "[*] writing output to \\$OutFileHost\$OutputFile" -ForegroundColor Cyan
    }
    
    $Listener_Code = {
        C:\users\gabrurgent\iperf\iperf3.exe -s >> \\$OutFileHost\$OutputFile
    }

    $Connector_Code = {
        $Server = $args[0]
        Write-Host "[*] Testing bandwidth from $env:COMPUTERNAME to $Server" -ForegroundColor Cyan
        C:\users\gabrurgent\iperf\iperf3.exe -c $Server
        Write-Host "[+] Finished testing from $env:COMPUTERNAME to $Server" -ForegroundColor Green
    }

    foreach($Server1 in $Servers){
        
        $Listener_Session = New-PSSession -ComputerName $Server1

        Invoke-Command                 -Session $Listener_Session -ScriptBlock $Listener_Verbose_Code -ArgumentList $env:COMPUTERNAME, $OutputFile

        $Listener_Job = Invoke-Command -Session $Listener_Session -ScriptBlock $Listener_Code -AsJob

        Start-Sleep -Seconds 1
        
        foreach($Server2 in $Servers){
            if($Server2 -ne $Server1){
                Invoke-Command -ComputerName $Server2 -ScriptBlock $Connector_Code -ArgumentList $Server1
            }
        }

        Write-Host "[*] Stopping Listener on $Server1" -ForegroundColor Cyan
        $Listener_Job | Stop-Job
        $Listener_Job | Remove-Job

        $Listener_Session | Remove-PSSession
        Write-Host "[+] Listener stopped on $Server1" -ForegroundColor Green
    }
}