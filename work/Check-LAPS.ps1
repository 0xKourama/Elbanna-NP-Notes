#Laps Properties
#ms-mcs-admpwd
#ms-mcs-admpwdexpirationtime
Get-ADComputer -Filter * -Server frank-PDC -Properties ms-mcs-admpwd, ms-mcs-admpwdexpirationtime, ipv4address |
Where-Object {$_.ipv4address} | Select-Object -Property name, ms-mcs-admpwd, ms-mcs-admpwdexpirationtime