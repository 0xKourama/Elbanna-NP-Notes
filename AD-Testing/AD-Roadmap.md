# OSINT (Userlist generation)
1. Generate user list from **LinkedIn/company website** using `theHarvester` tool
2. Use **hunter.io** to search for emails and get an idea on user naming convention
3. generate list of common passwords schemes
	1. Most common passwords
	2. Usernames as passwords
	3. Company-name conventions

# Network/AD Pentest
1. Start **Nessus** (basic network scan) in the background
2. **AD pentesting**
	1. **[Network Poisoning + Relay Attacks]** start **`Responder`** and start relaying to target list ---> obtain AD naming convention to modify userlist
	2. **[Social Engineering]** gather creds with fake UPnP devices using **`Evil-SSDP`**
	3. **[Identifing Domain Controllers]** Doing a quick **`nmap`** scan searching for DNS, Kerberos or LDAP ports: 53, 88, 389
	4. **[DNS Reconnaissance]** Do a reverse DNS lookup bruteforce to find other high-value targets **-->** set priority list for interesting host names
	5. **[Username Enumeration]**
		1. Enumerate **Kerberos** with OSINT-Generated wordlist (*shorten according to convention found with responder*)
		2. Enumerate **LDAP** (checking if anonymous bind is enabled)
		3. Enumerate **SMB** guest/null/anonymous authentication/rid-brute
		4. Enumerate **RPC**
	6. **[Low Hanging Fruit]**
		1. **ZeroLogon / Eternal Blue**
		2. **Exchange Proxy Logon**
	7. **[Identifying ADCS]**
	8. **[Unauthenticated AD Attacks]**
		1. ASREPRoasing
		2. Password Spraying]**
			1. Try to obtain**Domain Password Policy**
			2. Start spraying with generated password list
	9. **[Authenticated AD Attacks]**  
		1. Domain Controller <= Microsoft Server 2012 R2? --> MS14-068 (a.k.a pykek)		
		2. **[ADCS Attacks]**
			1. check for **samAccountName spoofing**
			2. CVE-2022-26923 (a.k.a certifried)
			3. PetitPotam
		3. **Drop the MIC** (CVE-2019-1040)
		4. **PrivExchang**
		5. **Remote Print Nightmare** CVE-2021-1675
		6. **GPO Abuse**
		7. Search for **shell access** using SMB/WinRM
		8. **SMB Share Enumeration**
			1. Enumerate **Group Policy Preferences** (MS14-025)
			2. Passwords in files? --> search for keywords like "password" "creds" in readable files
			3. writable SMB share? --> plant **SCF/LNK/INI** file/malicious office document (macro attack) with interesting name (*to attract a user to open it*)
		9. **Full AD User/Computer Enumeration**
			1. Do another full **ASREPRoast**
			2. Check for **stored passwords** in user description field (`ldapdomaindump` or `Get-ADUser` from a RSAT-enabled & Network Authenticated user)
			3. Check for interesting computers to target
		10. **Kerberoast**
		11. Run **Bloodhound**
			1. Conduct **ACL attacks** with `powerview` to abuse **dangerous rights** (ex: password reset)
			2. Check for **Kerberos unconstrained/contrained delegation**
			3. **[High Privilege Group Memberships Abuse]**
				1. **DNSAdmins** --> Escalate to domain admin via DLL hijacking
				2. **Exchange Windows Permissions** --> DCSync
				3. **Backup Operators** --> backup `NTDS.dit`
				4. **LAPS Group** --> Ability to read **LAPS** passwords
				5. **gMSA Group** Ability to read **gMSA** passwords
				6. **Exchange Windows Permissions** --> DCSync
				7. **Key Admins/Enterprise Key Admins** With ADCS, do shadow credentials --> DCSync
				8. **Account Operators** --> modify group memberships --> exploit all above abilities from group memberships
				9. **Server Operators** --> administrative access to non-domain controller servers
			4. **[Hunting For High Privilege Users]**
				1. Impersonate tokens with `incognito.exe`
				2. Logged in through RDP?
					1. Hijack Session
					2. Dump Credentials
				3. Dump Creds
					1. SAM
						1. **Pass-the-Hash** and spray the network using `crackmapexec` to check for reused local admin password
						2. Attempt password cracking and and trying across all other authentication channels
					2. Attempt Dumping **LSASS** Memory
						1. Task Manager
						2. **procdump**
						3. rundll
						4. **Powersploit** outminidump.ps1
						5. if Avast AV found, try using it to dump LSASS
	13. **[Local Privilege Escalation]**
		1. Run **WinPEAS** --> regular windows pricesc paths
		2. `SeImpersonatePrivilege`? Abuse Potato attacks (SweetPotato)
		3. test **Local Print Nightmare** CVE-2021-1675
		4. **SMBGHost** CVE-2020-0796
		5. **HiveNightmare/SeriousSam** 2021-36934
		6. NetNTLMv1 found? Coerce with `petitpotam` and submit hash for cracking on [crack.sh](https://crack.sh/)
	14. **[After gaining Administrative Access]** got local admin?
3. **[Resume Network Exploitation]** Retrieve Nessus scan results
	1. Find most (critical + exploitable) vulnerabilities
	2. Check for known, safe and trusted exploits on
		1. **Metasploit**
		2. **ExploitDB**
		3. **GitHub** PoCs (review source code before execution)
	3. Check for clear-text protocols and perform MitM attacks (ARP poisoning)
	4. Attack common applications with specialized tools (ex: Oracle --> ODAT)
	5. Check for **log4j**