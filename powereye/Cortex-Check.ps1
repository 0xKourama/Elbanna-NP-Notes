$Computers = (Test-Connection -ComputerName (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).name -AsJob -Count 1 | Wait-Job | Receive-job |Where-Object {$_.statuscode -eq 0} | select-object -expandproperty address)
$script = {
    $result = @{} | Select-Object -Property ComputerName, CortexInstalled, CortexVersion
    $versions = get-wmiobject win32_product | Where-Object {$_.name -like '*cortex*'} | Select-Object -ExpandProperty Version
    if(!$versions){
        $result.CortexInstalled = $false
        $result.CortexVersion = 'N/A'
    }
    else{
        $result.CortexInstalled = $true
        $result.CortexVersion = $versions
    }
    $result.ComputerName = $env:COMPUTERNAME
    Write-Output $result
}
Invoke-Command -ComputerName $Computers -ScriptBlock $script -ErrorAction SilentlyContinue | Select-Object -Property * -ExcludeProperty RunSpaceID,PSComputerName | Out-GridView