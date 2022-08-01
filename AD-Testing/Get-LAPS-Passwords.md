```powershell
Get-ADComputer -Filter {ms-mcs-admpwd -like '*'} -Properties ms-mcs-admpwd | Select-Object name, ms-mcs-admpwd
```