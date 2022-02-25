cmd /c "$env:PUBLIC\winpcap-nmap-4.13.exe /S"
cmd /c $CDPtoWMIPath | Out-Null
Get-WmiObject -Class ninet_org_wmiCDP -ErrorAction Stop | Select-Object PortID, DeviceID
cmd /c "c:\users\public\uninstall.exe /S"
Get-WmiObject -Class ninet_org_wmiCDP | Remove-WmiObject