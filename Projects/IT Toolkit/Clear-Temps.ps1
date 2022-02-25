Get-ChildItem C:\users\default\AppData\Local\* -Include *.sqm -Recurse -Force | Remove-Item
Remove-Item -Path C:\users\*\AppData\Local\Temp\* -Recurse -Force
Remove-Item -Path C:\Windows\Temp\* -Recurse -Force