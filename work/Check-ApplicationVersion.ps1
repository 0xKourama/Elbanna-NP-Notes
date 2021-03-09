param(
    $ComputerName,
    $ApplicationName
)
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    $ApplicationName = $args[0]
    Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' |
    Where-Object {$_.displayname -like "*$ApplicationName*"} |
    Select-Object DisplayName, Version
} -ArgumentList $ApplicationName