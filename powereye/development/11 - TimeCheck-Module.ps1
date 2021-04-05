$Online = Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
          Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0} | Select-Object -ExpandProperty Address
$Script = {
    $PDCTime = $args[0]
    $Date = Get-Date
    $Obj = New-Object -TypeName PSObject -Property @{
        ComputerName     = $env:COMPUTERNAME
        Date             = $Date
        PDCTimeOffsetMS  = [math]::Abs((New-TimeSpan -Start $PDCTime -End $Date).TotalMilliseconds)
    }
    Write-Output $Obj
}
$Sessions = New-PSSession -ComputerName $Online -ErrorAction SilentlyContinue

$PDCTime = Invoke-Command -ComputerName  -ScriptBlock {Get-Date} |
        Select-Object -Property * -ExcludeProperty PSShowComputerName, RunSpaceID, PSComputerName

$Results = Invoke-Command -Session $Sessions -ScriptBlock $Script -ArgumentList $PDCTime -ErrorAction SilentlyContinue