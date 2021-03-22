$Ignored_Shares = @(
    'IPC$'
    'C$'
    'ADMIN$'
)
Get-SmbShare | Where-Object {$Ignored_Shares -notcontains $_.Name} | Select-Object -Property Name, Path, Description