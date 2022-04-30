### Summary
- A **windows machine** with `Anonymous FTP` allowed. *Inspecting the contents* reveals a **documents folder** one of which tells us that *RTF documents are being reviewed and converted by someone*.
- *Using this information,* we craft a *malicious document* using **CVE-2017-0199** and send it to a certain user called `nico` via the open `SMTP` port (*We find his username by checking the metadata of the documents on FTP*).
- *When the document is opened,* we get a shell back as `nico` and start enumerating the machine.
- *With BloudHound,* we find that nico has a `WriteOwner` right over another user `herman` who has a `WriteDACL` over a certain group called `Backup_Admins`.
- We abuse the `WriteOwner` right to grant ourselves the right to reset `herman`'s password and abuse the `WriteDACL` to add him to the `Backup_Admins` group.
- We then find out that `Backup_Admins` have access to a certain folder called `Backup Scripts` on the `Administrator`'s desktop on the box.
- *Within that folder,* we find a script that contains the password for the local administrator which works and we use it to login using the open `SSH` port.
- A *Similar path* exists with another user `tom` whom his credentials are present in a `creds.xml` file on `nico`'s desktop as a `secure string`.
- The clear-text credentials can be retrieved to gain access as `tom` using `SSH`. `tom` has `WriteOwner` on `claire` who has a `WriteDACL` on `Backup_Admins`.
- Another path exists with abusing the `SeLoadDriverPrivilege` held by `tom` since he's a member of the `Print Operators` group.
- The box is also vulnerable to `CVE-2019-1458` and `CVE-2018-8440` local privilege escalation exploits.

---

