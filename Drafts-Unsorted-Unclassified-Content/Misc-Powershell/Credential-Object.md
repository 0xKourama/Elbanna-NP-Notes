# one-liner
```powershell
New-Object System.Management.Automation.PSCredential ("<USERNAME>", (ConvertTo-SecureString "<PASSWORD>" -AsPlainText -Force))
```

# broken down
```powershell
[string]$userName = 'webadmin'
[string]$userPassword = 'FG9I@be27W6T@'

[securestring]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)

New-Object System.Management.Automation.PSCredential ("webadmin", ConvertTo-SecureString "FG9I@be27W6T@" -AsPlainText -Force)
```