Write-Host -ForegroundColor Cyan '[*] Testing connectivity'
$Online = Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
          Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0} | Select-Object -ExpandProperty Address
Write-Host -ForegroundColor Cyan "[*] $($Online.Count) Online computers found"

Write-Host -ForegroundColor Cyan '[*] Starting sessions with computers'

$Sessions = New-PSSession -ComputerName $Online -ErrorAction SilentlyContinue

Write-Host -ForegroundColor Cyan '[*] Collecting time results'

$Results = Invoke-Command -Session $Sessions -ScriptBlock {Get-Date} -ErrorAction SilentlyContinue

$PDCTime = $Results | Where-Object {$_.PSComputerName -eq "$((Get-ADDomain).PDCEmulator -replace ".$env:USERDNSDOMAIN" )"}

$Results | Foreach-Object {
    Add-Member -InputObject $_ -Type NoteProperty -Name PDCTimeOffsetS -Value ([math]::Round((New-TimeSpan -Start $_ -End $PDCTime).TotalSeconds, 2))
    Add-Member -InputObject $_ -Type NoteProperty -Name PDCTimeOffsetMS -Value ((New-TimeSpan -Start $_ -End $PDCTime).TotalMilliseconds -as [int])
}

$Results | Select-Object -Property @{n='ComputerName';e={$_.PSComputerName}}, PDCTimeOffsetS, PDCTimeOffsetMS | Format-Table -AutoSize

Clear-Variable -Name Results

Remove-PSSession -Session $Sessions