Function Return-OnlineComputers{
    param(
        [Parameter(ValueFromPipeline=$true)][String[]]$ComputerNames
    )
    Test-Connection -ComputerName $ComputerNames -Count 1 -AsJob |
    Receive-Job -Wait |
    Where-Object {$_.StatusCode -eq 0} | 
    Select-Object -ExpandProperty Address
}