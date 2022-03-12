# Telnet --> remote management

# FTP --> file sharing
## connecting to ftp
## getting files
## anonymous logon

# SMB --> file sharing
## smbclient
### anonymous logon
### listing shares
### getting files

# network communication model (client-server architechture)

# SSH and public-key cryptography
# RDP
## using default admin account based on OS
### Windows: Administrator
### Linux: root

# directory enumeration
# extension enumeration
# admin pages
# default admin credentials (admin/admin)

# PII

# sql injection for authentication bypass using `' or 1=1 -- -` and any password

# using `mysql` command to login as root without a password
## using databases enumeration commands:
1. `show databases;`
2. `use <DBNAME>;`
3. `show tables;`
4. `select * from <TABLENAME>;`


# status codes for responses to client requests and showing errors

# curl verbose usage and parameters

# virtual hosts

# guessing common passwords

# avoiding locking login interfaces by brute force attacks

# hydra http-post bruteforce

# smb command execution with impacket

# using cookie tampering to bypass authentication

# using wfuzz to fuzz cookie values

# uploading a php reverse shell

# looting `/var/www/html` directory

# using creds to pivot as another user

# finding SUID binary using `find / -type f -perm /4000 2>/dev/null | xargs ls -l`

# jenkins exploitaiton using weak credentials
# finding out MSF brute force module wasn't working
# using `/script` for silent code execution and using the `Groovy` lanuage payload to execute a reverse shell

# impacket mssqlclient.py usage (note using the `-windows-auth` flag)
`python3 mssqlclient.py -windows-auth ARCHETYPE/sql_svc@10.129.83.40`

# finding passwords in `.DTSCONFIG` file:
*frome fileinfo.com:*
A DTSCONFIG file is an XML configuration file used to apply property values to SQL Server Integration Services (SSIS) packages. The file contains one or more package configurations that consist of metadata such as the server name, database names, and other connection properties to configure SSIS packages.

# enabling `xp_cmdshell`
# download a nishang reverse shell and executing it

# using winpeas
# enumerating console history

# using impacket's `psexec.py` for remote code execution

# cracking md5 hash
# cracking zip file password using `zip2john`

# SQLmap sql injection with the `--os-shell` switch and using authenticated cookie

# bash reverse shell

# rummaging through `/var/www/html` for passwords

# find postgresql hash in `pg_authid` which we *couldn't* crack :/

# finding `postgresql` password :D

# sudo vi there
## Gtfo bins
1. `/usr/bin/vi`
2. `:set shell=/bin/bash`
3. `:shell`

----------------------------------------------------------------------

# Machine: unified
# version enumeration
# log4j exploitation
# non default mongodb port
# mongo DB name ... we used the `mongo` command to connect and found the `ace` db.
# we used basic syntax to enumerate the `admin` collection *(Note: collections are the table equivalents in other databases)*
## listing databases using `show dbs`
## using a database using `use <db>`
## listing collections using `show collections`
## enumerating elements in a collection using `db.<collection>.find()`

# we identified the x_shadow field as a shadow file hash `sha512crypt $6$, SHA512 (Unix) 2` in hashcat
# *instead of cracking it,* we use the update command to change the hash generated using `mkpasswd -m sha-512 P3@ceW1thHTB` and log in as administrator the unifi network administrator console
```
db.admin.update(
	{
		"_id":ObjectId("61ce278f46e0fb0012d47ee4")
	}
	{
		$set: {
			"x_shadow" : "$6$zyPslwl.HhmblRYH$.39gZbIPfAdOa1IxGeP16F0jarpNztFp5pMyeLAi0HuviqjpQdyd/X7te0Z6fpKNIZ6zP0aBoHriM7yg5OOL60"
		}
	}
)
```
# *after loggin in,* we started **EXPLORING THE APP FUNCTIONALITY** and we find that we can view the root user password in the `device authentication` section under `Settings > Site`

-------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------

# Tasks:
1. configure ftp
2. configure nfs
3. configure mariadb
4. configure nginx
5. configure apache
5. configure CMSs
	1. wordpress
	2. magento
	3. drupal
	4. joomla
+ play around with them

# what i fucking hate about hack the box
1. difficult level. what the fuck is easy????????? according to whom????? mr.robot crew?

# hack the box is about making you learn the technology and what can be done to hack it