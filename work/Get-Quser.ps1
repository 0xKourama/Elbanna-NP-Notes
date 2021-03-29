Invoke-Command -ComputerName (
    Test-Connection (
        (Get-ADComputer -Filter * -Properties IPV4address | Where-Object {$_.IPV4Address} |Select-Object -ExpandProperty Name)
    ) -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} |Select-Object -ExpandProperty Address
) -ScriptBlock {
    $Quser = ((quser) -replace "\s{2,}",',' -replace "^\S",'' | ConvertFrom-Csv | Format-Table -AutoSize |Out-String).trim()
    if(!$Quser){$Quser = 'None'}
    Write-Host "$env:COMPUTERNAME`n$Quser`n-----------------------------------------------------------------------------------"
} -ErrorAction SilentlyContinue