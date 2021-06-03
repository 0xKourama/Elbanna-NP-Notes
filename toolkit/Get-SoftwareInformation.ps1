Get-ItemProperty -Path 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' |
Where-Object {$_.Displayname} |
Select-Object -Property 'DisplayName','DisplayVersion','Publisher','InstallDate' |
Sort-Object -Property DisplayName