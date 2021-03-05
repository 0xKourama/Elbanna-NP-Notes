param(
    $ComputerList
)
if(!$ComputerList){Write-Host '[!] Usage: Get-OnlineComputers -ComputerList <COMPUTERS>' -ForegroundColor Yellow}
else{
    Test-Connection -ComputerName $ComputerList -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0}
}