# Test Cases (after scope verification)

# OSINT
1. generate user list from LinkedIn/company website/
2. Use hunter.io to get an idea on username convention
3. generate list of common passwords schemes including company name
# network pentest
1. [time saving] start nessus (basic network scan) in the background + applying scan precautions based on network infrastructure
2. AD pentesting
	1. [time saving] find targets without SMB signing enabled `crackmapexec smb <SUBNET> --gen-relay-list <OUT_FILE>`
	2. [time saving + network poisoning] start `responder` and start relaying to target list ---> obtain AD naming convention to modify userlist
	3. [SSDP] gather creds with fake UPnP devices using `evil-ssdp`
	4. Identify domain controllers by a quick `nmap` scan searching for DNS, Kerberos and LDAP ports: 53, 88, 389 --> bruteforce DNS to get a list of all server names --> set priority list for interesting computer names
	5. [time saving + username enumeration] start `kerbrute` to enumerate AD users + try enumeration through ldap using `ldapsearch` + try enumeration using SMB through guest/null/anonymous authention or through RPC using `enum4linux-ng`
	6. [low hanging fruit] test for zero logon (on domain controllers) + eternal blue (on domain controllers or any other host)
	7. [low hanging fruit] test for proxy logon (metasploit version) if exchange servers are found
	8. [low hanging fruit] run nmap scan for port 80 --> `curl` for "http://<IP>/certsrv" to detect Active Directory Certificate services --> Relay using PetitPotam
	9. [unauthenticated attacks 1 - ASREPRoasing] got a userlist? --> ASREPRoast
	10. [unauthenticated attacks 2 - Password Spraying] Try to obtain password policy `crackmapexec smb <DC_IP> -u '' -p '' --pass-pol` --> start spraying with most common passwords
	11. [authenticated attacks without shell access] got user?
		1. search for shell access using `crackmapexec` `smb` and `winrm`
		2. ADCS? --> use `noPac.py` + CVE-2022-26923 (a.k.a certifried)
		3. Exchange? --> use `privexchange` relay attack to domain admin
		4. Drop the MIC (CVE-2019-1040)
		5. Print Nightmare CVE-2021-1675
		6. test for pykek (MS14-068)
		7. pull all AD users --> another full ASREPRoast + check for stored passwords in description AD attribute
		8. pull all AD computer names --> check for interesting computers
		9. Kerberoast
		10. Bloodhound
			1. conduct ACL attacks with `powerview` to abuse dangerous rights
			2. Abuse high privileges group memberships
				1. DNSAdmins --> Escalate to domain admin
				2. Exchange Windows Permissions --> DCSync
				3. Backup Pperators --> backup NTDS.dit
				4. Account Operators --> non-high-privilege group membership addition
				5. Server Operators --> administrative access to non-domain controller servers
			3. locate computers where domain admins are logged in
		11. Enumerate Group Policy Preferences (MS14-025)
		12. enumerate SMB share access with the obtained user using `crackmapexec` --> writable SMB share? --> plant SCF file/plant malicious office document (macro attack) with interesting name (to attract a user to open it)
		13. check for contrained/unconstrained delegation
		14. check for readable LAPS passwords
	12. [authenticated attacks with shell/rdp access] got user?
		1. [privilege escalation] winpeas --> regular windows pricesc paths
		2. [privilege escalation] potato attacks
		3. [privilege escalation] print nightmare CVE-2021-1675
		4. [privilege escalation] SMBGHost CVE-2020-0796
		5. [privilege escalation] HiveNightmare/SeriousSam 2021-36934
	13. [after gaining administrative access] got locl admins?
		1. dump SAM and get local admin NTLM hash
			1. pass-the-hash and spray the network using `crackmapexec` to check for reused local admin password
			2. attempt cracking password and stuffing it accross all other authentication channels
			3. antivirus?
				1. attempt uninstalling
				2. attempt stopping/disabling its services
				3. attempt deleting its unprotected files
				4. attempt obfuscating scripts
			4. attempt dumping lsass memory
				1. task manager
				2. procdump
				3. rundll
				4. outminidump.ps1
				5. if avast AV, try using it to dump lsass
3. [resume network exploitation] retrieve nessus scan results
	1. find most (critical + exploitable) vulnerabilities
	2. check for known, safe and trusted exploits on
		1. Metasploit
		2. ExploitDB
		3. GitHub PoCs (review source code before execution)
	3. check for clear-text protocols and perform MitM attacks (ARP poisoning)