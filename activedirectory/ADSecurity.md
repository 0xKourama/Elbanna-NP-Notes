# Defense
1. Do not allow or limit login of Domain Admins to any other machine other than the Domain Controllers. If logins to some servers is necessary, do not allow other administrators to login to that machine. We can use logonworkstations feature in AD.
2. (Try to) Never run a service with a Domain Admin. Many credential theft protections are rendered useless in case of a service account.
3. Audit event 4672 (admin logon)
4. Enable audit privilege use (event ID 4673) for sensitive privilege use
5. Event ID 4611 A trusted logon process has been registered with the local Security authority
6. defense against skeleton key.
	- Running lsass.exe as a protected process (forces attacker to load a kernel mode driver)
	- This need to be tested thoroughly as many drivers and plugins may not load with the protection
	- Command: New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ -Name RunAsPPL -Value 1 -Verbose
	- Verify after reboot: Get-WinEvent -Filterhashtable @{Logname='System';ID=12} | Where-Object {$PSItem.Message -like "*Protected process*"}
7. Defense against DSRM logon (Event ID 4657) - Audit Creation/change of HKLM:\System\CurrentControlSet\Control\Lsa\DsrmAdminLogonBehavior
8. Defense against Malicious SSP (Event ID 4657) - Audit Creation/change of HKLM:\System\CurrentControlSet\Control\Lsa\SecurityPackages
9. Defense against kerberoast (Event ID 4769) : A kerberos ticket was requested.
	Mitigations:
	- Service account password should be hard to guess (> 25 characters)
	- Using Managed Service Accounts (Automatic change of password periodically and delegated SPN management)
	Detection:
	- on Event 4769 we must filter the logs:
	1. Service name should not be 'krbtgt'
	2. Service name does not end with '$' (to filter out machine accounts used for services)
	3. Account name should not be 'machine@domain' (to filter out requests from machines)
	4. Failure code is '0x0' (to filter out failures, 0x0 is success)
	5. Most importantly, ticket encrypt type is '0x17'
10. Defense against Delegation attacks:
	- Limit administrator logins to specific servers
	- Set 'Account is sensitive and cannot be delegated for privleged accounts.
11. Defense against ACL Attacks:
	Security events:
	- 4662 - An operation was performed on an object
	- 5136 - A directory service object was modified
	- 4670 - Permissions on an object were changed
	*useful tool: AD ACL Scanner*
12. **Solution: Microsoft Advanced Threat Analytics**


# Tasks:
1. dump lsass using procdump and shoft tawfik extraction using mimikatz

# Notes:
1. We can create a temp domain admin: Add-ADGroupMember -Identity 'Domain Admins' -Members newDA -MemberTimeToLive (New-TimeSpan -Minutes 20)