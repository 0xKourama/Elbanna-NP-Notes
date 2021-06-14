$computers = return-adonlinecomputers
$servers = @('192.168.3.4','192.168.3.5','192.168.3.2','192.168.3.1','192.168.4.90','192.168.3.3')
$results = @()
foreach($server in $servers){
    foreach($computer in $computers){
        Write-Host -ForegroundColor Cyan "[*] querying $computer from $server"
        $results += [pscustomobject][ordered]@{
            Server = $server
            QueryTarget = $computer
            QueryTime = (measure-command -expression {resolve-dnsname -name $computer -server $server}).TotalMilliseconds
        }
    }
}