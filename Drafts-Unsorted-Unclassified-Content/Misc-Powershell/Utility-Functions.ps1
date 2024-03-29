Function Return-OnlineComputers{
    param(
        [Parameter(ValueFromPipeline=$true)][String[]]$ComputerNames
    )
    Test-Connection -ComputerName $ComputerNames -Count 1 -AsJob |
    Receive-Job -Wait |
    Where-Object {$_.StatusCode -eq 0} | 
    Select-Object -ExpandProperty Address
}

Function Return-ADOnlineComputers{
    Test-Connection -ComputerName (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name -Count 1 -AsJob |
    Receive-Job -Wait |
    Where-Object {$_.StatusCode -eq 0} | 
    Select-Object -ExpandProperty Address
}
