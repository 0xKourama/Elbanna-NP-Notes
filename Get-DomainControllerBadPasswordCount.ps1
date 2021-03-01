$dcs = Get-ADDomainController -Filter * | Select-Object -ExpandProperty name
$cmd = {
    Get-ADUser -Filter * -Properties mail,badpwdcount |
    Sort-Object -Descending -Property badpwdcount |
    select -First 5 -Property name,mail,badpwdcount
}
Invoke-Command -ComputerName $dcs -ErrorAction SilentlyContinue -ScriptBlock $cmd |
Select-Object * -ExcludeProperty RunspaceId |
Sort-Object -Property badpwdcount -Descending |
Format-Table -AutoSize