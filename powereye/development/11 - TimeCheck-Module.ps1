Write-Host -ForegroundColor Cyan '[*] Testing connectivity'
#$Online = Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
          #Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0} | Select-Object -ExpandProperty Address
Write-Host -ForegroundColor Cyan "[*] $($Online.Count) Online computers found"

Write-Host -ForegroundColor Cyan '[*] Starting sessions with computers'

#$Sessions = New-PSSession -ComputerName $Online -ErrorAction SilentlyContinue

Write-Host -ForegroundColor Cyan '[*] Collecting time results'

$Results = Invoke-Command -Session $Sessions -ScriptBlock {Get-Date} -ErrorAction SilentlyContinue

$PDC = (Get-ADDomain).PDCEmulator -replace ".$env:USERDNSDOMAIN"

$PDCTime = $Results | Where-Object {$_.PSComputerName -eq $PDC}

$Results | Foreach-Object {
    Add-Member -InputObject $_ -Type NoteProperty -Name PDCTimeOffsetS -Value ([math]::Round((New-TimeSpan -Start $_ -End $PDCTime).TotalSeconds, 2))
    Add-Member -InputObject $_ -Type NoteProperty -Name PDCTimeOffsetMS -Value ((New-TimeSpan -Start $_ -End $PDCTime).TotalMilliseconds -as [int])
}

$Results = $Results | Select-Object -Property @{n='ComputerName';e={$_.PSComputerName}}, PDCTimeOffsetS, PDCTimeOffsetMS

$Results | ft

<#
$AdjustScript = {
    [int]$Offset = ($args | Where-Object {$_.Computername -eq $env:COMPUTERNAME}).PDCTimeOffsetMS
    Write-Host -ForegroundColor Yellow "[!] $env:COMPUTERNAME Offset: $Offset"
    $Adjusted_date = (Get-Date).AddMilliseconds($Offset) 
    Set-Date -Date $Adjusted_date -whatif
    Write-Host -ForegroundColor Magenta "[#] $Adjusted_date"
}

$AdjustedResults = Invoke-Command -Session $Sessions -ScriptBlock $AdjustScript -ArgumentList $Results

$PDCNewTime = $AdjustedResults | Where-Object {$_.PSComputerName -eq $PDC}

$AdjustedResults | Foreach-Object {
    Add-Member -InputObject $_ -Type NoteProperty -Name PDCTimeOffsetS -Value ([math]::Round((New-TimeSpan -Start $_ -End $PDCNewTime).TotalSeconds, 2))
    Add-Member -InputObject $_ -Type NoteProperty -Name PDCTimeOffsetMS -Value ((New-TimeSpan -Start $_ -End $PDCNewTime).TotalMilliseconds -as [int])
}

$AdjustedResults = $AdjustedResults | Select-Object -Property @{n='ComputerName';e={$_.PSComputerName}}, PDCTimeOffsetS, PDCTimeOffsetMS

$AdjustedResults | Format-Table -AutoSize

$Measurements = $AdjustedResults | Measure-Object -Property PDCTimeOffsetMS -Minimum -Maximum -Average

$Measurements

Write-Host "Variance: $(($Measurements.Minimum + $Measurements.Maximum)/2)"

#Remove-PSSession -Session $Sessions
#>