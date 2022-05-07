### Summary
- Noticing the open ports: DNS, Kerberos, LDAP & SMB, we know we're up against a Windows Domain Controller.
- LDAP Enumeration reveals a base-64 encoded password which was embedded in a unique Active Directory user attribute.
- Decoding the password grants access to the `r.thompson` user who happens to have `read` access to the `data` SMB share.
- Exploring the share, we find a `VNC`-related `.reg` file which contains an encrypted password in hexadecimal format.
- We also find an e-mail about a deleted `TempAdmin` who has a similar password to the normal (admin) user.
- After we crack the password with a tool called `vncpwd`, we gain access to the `s.smith` user.
- Enumerating the SMB access for `s.smith`, we find that he has `read` access to the `audit` share.
- The `audit` share contained an `sqlite3` database file. Enumerating it, we find an encrypted password for the `arksvc` user.
- We also find two files `CascAudit.exe` and `CasCrypto.dll` which we reverse to find the necessary information to decrypt the `arksvc` password.
- We authenticate as the `arksvc` user and find that he's a member of the `AD Recycle Bin` group.
- Combining this information with the e-mail contents, we're enticed to check the AD users that were deleted.
- Using PowerShell to fetch the deleted users with all their properties, we find the password for the `Administrator` account in the same unique attribute for the `TempAdmin` user. We use to authenticate and we gain full access to the machine.

---

### Nmap
```
PORT      STATE SERVICE       VERSION
53/tcp    open  domain        Microsoft DNS 6.1.7601 (1DB15D39) (Windows Server 2008 R2 SP1)
| dns-nsid: 
|_  bind.version: Microsoft DNS 6.1.7601 (1DB15D39)
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2022-05-06 11:02:19Z)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: cascade.local, Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds?
636/tcp   open  tcpwrapped
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: cascade.local, Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49154/tcp open  msrpc         Microsoft Windows RPC
49155/tcp open  msrpc         Microsoft Windows RPC
49157/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49158/tcp open  msrpc         Microsoft Windows RPC
49170/tcp open  msrpc         Microsoft Windows RPC
Service Info: Host: CASC-DC1; OS: Windows; CPE: cpe:/o:microsoft:windows_server_2008:r2:sp1, cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   2.1: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-05-06T11:03:13
|_  start_date: 2022-05-06T10:54:20
```
DNS + Kerberos + LDAP + SMB = Domain Controller :D
WinRM = Shell Access maybe :)

From `nmap` version detection and scripts:
- OS: Windows Server 2008 R2 SP1
- Domain Name: Cascade.local
- Hostname: CASC-DC1

### Checkpoint: Listing Possible Enumeration/Exploitation Paths
Having the port data, we go over our gameplan:
1. RPC
	1. `enum4linux-ng`
		1. userlist
		2. password policy
2. Kerberos
	1. `kerbrute` user enumeration
	2. got userlist? -> ASREPRoast
	2. got userlist? -> password spray
		1. Common Passwords
		2. Themed Passwords
	3. got working creds?
		1. Kerberoast
		2. Password Reuse
3. LDAP
	1. `ldapsearch`
4. SMB
	1. `crackmapexec` share enumeration
		1. Null
		2. Guest
		3. Anonymous
	2. Share access
		1. Read?
			1. File content
			2. User Activity Information
			3. Metadata
			4. Alternate Data Streams?
		2. Write?
			1. SCF Attack
			2. Edit Scripts
5. got AD creds?
	1. BloodHound
		1. DCSync users
		2. High priv group membership
		3. ACL attacks and permissions abuse
	2. Got creds? + Old DC?
		1. MS14-068

