Param(
    $Ports,
    $IP
)
$Open_ports = @()
$Index = 1
$ErrorActionPreference = 'SilentlyContinue'
foreach($Port in $Ports) {
    Write-Progress -Activity "Open Ports: $($Open_ports -join ', ')" `
                   -Status "[$Index/$($Ports.count)] [$([Math]::Round(($Index/$Ports.Count)*100,2))%] Scanning port $Port" `
                   -PercentComplete (($Index/$Ports.Count)*100)
    $Socket = New-Object System.Net.Sockets.TcpClient
    $Socket.BeginConnect($IP, $Port, $null, $null) | Out-Null
    Start-Sleep -Milliseconds 100
    If($socket.Connected){
        $Open_ports += $Port
    }
    else{
        Start-Sleep -Milliseconds 100
        If($socket.Connected){
            $Open_ports += $Port
        }
    }
    $socket.Close()
    $Index++
}