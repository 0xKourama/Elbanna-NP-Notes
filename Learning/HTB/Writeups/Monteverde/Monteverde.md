### Summary
- Another Windows Domain Controller Machine.
- We get a full list of domain users by enumerating **RPC** and are able to login with a user called `SABatchJobs` whose password was his own username.
- *Enumerating the* **SMB** *access for this user,* we find that he could read a certain **XML** file which contained a password.
- *After spraying the password over all users,* it turns out to belong to another user called `mhope` who happens to be a member of the `Azure Admins` AD group which was interesting.
- *Additionally,* we found a special folder called `.Azure` in `mhope`'s user profile. It contained remnants of a connection made to **Azure**.
- We also find `Azure AD Connect` installed in the `C:\Program Files` directory which all stuck out and brought our attention to search for **Privilege Escalation** paths along that way.
- *Searching* **Google** *for* `Privilege Escalation Using Azure AD Connect`, we find a **blog post** that gives us a bit of background on what `Azure AD Connect` does and how to exploit it to gain **Domain Admin** privileges.
- *Since* `Azure AD Connect` *uses an account to sync passwords between the* **On-prem Active Directory** *and the* **Azure Instance**, this account must be granted `DCSync` rights.
- The credentials for this account are stored within the local **MSSQL** database that's included in the installation of `Azure AD Connect`. *Even thought they are encrypted,* their decryption keys are also present in the same database.
- *Since our user* `mhope` *had access to that local DB,* We were able to extract and decrypt those credentials after doing a few tweaks to the **PowerShell** script provided by the blog author.
- They turn out to be the **Domain Administrator**'s creds and we root the box.

---

### Nmap
No special scan here. Just the standard `nmap` with `-sC` for default scripts and `-sV` for version detection on all ports.
```
PORT      STATE SERVICE       VERSION
53/tcp    open  domain        Simple DNS Plus
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2022-06-23 17:15:53Z)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: MEGABANK.LOCAL0., Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds?
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: MEGABANK.LOCAL0., Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
| http-server-header: Microsoft-HTTPAPI/2.0
| http-title: Not Found
9389/tcp  open  mc-nmf        .NET Message Framing
49667/tcp open  msrpc         Microsoft Windows RPC
49673/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49674/tcp open  msrpc         Microsoft Windows RPC
49676/tcp open  msrpc         Microsoft Windows RPC
49693/tcp open  msrpc         Microsoft Windows RPC
49747/tcp open  msrpc         Microsoft Windows RPC
Service Info: Host: MONTEVERDE; OS: Windows; CPE: cpe:/o:microsoft:windows
Host script results:
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-06-23T17:16:47
|_  start_date: N/A
```

We notice, it's a Windows box with few ports indicative of a domain controller: DNS on tcp 53, Kerberos on tcp 88 and LDAP on tcp 389.

Domain name is MEGABANK.LOCAL and Hostname is MONTEVERDE.

We also have WinRM open on tcp 5985 which would be handy to get remote code execution for any user present in either Administrators or Remote Management Users.

### Username Enumeration
Using a tool called `enum4linux-ng`, we are able to get a list of usernames through `RPC`:

Command: `enum4linx-ng -A 10.10.10.172`

![enum4linux-ng-output](enum4linux-ng-output.jpg)

No interesting info was there in the description except for one user: `AAD_987d7f2f57d2`

It said: `Service account for the Synchronization Service with installation identifier 05c97990-7587-4a3d-b312-309adfc172d9 running on computer MONTEVERDE.` which hinted at the possibility that this account might have DCSync rights. If that was true, then getting access as that user would mean game over :D

We take note of that and get the Domain Password Policy from the output as well.

![password-policy](password-policy.jpg)

No account lockout! We can spray like there's no tomorrow :D

### Password Spraying
Since ASREPRoasting is the first thing to do with a userlist, we tried that but weren't awarded with any hashes. So we turned to Password Spraying.

We make a quick list of common passwords to try like 'P@ssw0rd, Welcome1' etc. but don't get anything.

So we try using the usernames as passwords. We do this attack using `hydra` and we get a hit!

Command: `hydra -e s -L users.txt ldap3://10.10.10.172 -v`

where the `-e` flag with the `s` argument is the part instructing `hydra` to use the same entry for both username and password.

![hydra-attack](hydra-attack.jpg)

