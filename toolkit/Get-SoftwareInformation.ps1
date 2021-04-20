$PropertyList = @(
    'DisplayName'
    'DisplayVersion'
    'Publisher'
    'InstallDate'
)
$Reg_path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
Get-ItemProperty $Reg_path | Where-Object {$_.Displayname -ne $null} | Select-Object -Property $PropertyList | Sort-Object -Property DisplayName