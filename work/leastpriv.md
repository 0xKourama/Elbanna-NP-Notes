# least privilege task:

1. which accounts to limit (ALL WP?)

2. access control methodology
	1. computer groups (domain controllers, exchange servers, developer servers, special servers)
	2. role groups (exchange admins, backup, domain admins, developer accounts, backup)
	3. RDP

3. dangerous privileges (can be used in EoP):
	1. SeAssignPrimaryToken >> Replace a process level token
	2. SeBackup             >> Back up files and directories
	3. SeCreateToken        >> Create a token object
	4. SeDebug              >> Debug programs
	5. SeLoadDriver         >> Load and unload device drivers
	6. SeRestore            >> Restore files and directories
	7. SeTakeOwnership      >> Take ownership of files or other objects
	8. SeTcb                >> Act as part of the operating system

# steps:
1. test each privilege for effect
2. try removing the exploitable privileges from high accounts
3. decide which groupings to create based on required access levels

# what I think should be done:
1. limit access to what's necessary based on roles >> assign single privs
2. remove the exploitable privileges from everyone if possible >> prevent privesc
3. limit the use of administrators and switch to more granular accounts >> limit the higher privs
	then test those separately to see if the functionality would suffer or not >> temp

# Groups:
1. Exchange admin (local admin)
2. RDP
3. Developer (local admin)

```
Policy naming:

Generic group = all srv except exch and DC

Computer Group | Privilege Level
Exchange       | RDP priv           
Exchange       | shutdown priv
Exchange       | full priv (local admin)
Generic        | RDP Priv
Generic        | shutdown priv
Generic        | full priv (local admin)
Developer      | RDP Priv
Developer      | shutdown priv
Developer      | full priv (local admin)
```

# classifications
EU1MB9901: 192.168.3.202 wahba / nada
PST-SERVER1: 192.168.1.120 wahba / nada

ALL GENERIC (RDP + SHUTDOWN) abdo + hussein

All exchange + All DCs + PST-SERVER1 + office online (FRANK-OOS-O02, FRANK-OOS-O01) >> Islam + Pepo

## users:
1. Tawfik
2. Peter
3. Karim
4. Gabr
5. Wahba
6. Nada
7. Abdulrahman
8. Hussien
9. Islam
10. Mali
11. Sara

https://www.itprotoday.com/windows-78/implementing-least-privilege-ad

# what are the privileges of all built-in roles?
# what is the location of documentation on this?
# what would help find the privileges associated with services? AD, Exchange, IIS
# what can be done to find the privileges of the local groups?
# what needs to be done to track user activity?
# what in audit logs can be used to find user activity?
# what the practical steps to implement
# what workstations needs to be accesed by
1. high MGMT
2. exchange
3. Devs
4. generic
# what shortcuts are decent enough to make the project easier?
# what default groups can be used for managing administration tasks?
1. server operators
2. backup operators
3. power users
# what makes least privilege concept frustrating?
1. figuring out which exact privilege is required
2. admins aren't thrilled by the idea of limiting their access
# what audit types are required?
Audit privilege use
Audit object access
Audit directory service access >> MMC Domain Controller Security Policy snap-in
log on as a nonadministrator and try to perform the task. After your attempt fails, check the Security log for failed events that identify which right you lacked or which object you weren't able to access.



# Enterprise Admins
The Enterprise Admins (EA) group is located in the forest root domain, and by default, it is a member of the built-in Administrators group in every domain in the forest. The Built-in Administrator account in the forest root domain is the only default member of the EA group. EAs are granted rights and permissions that allow them to affect forest-wide changes. These are changes that affect all domains in the forest, such as adding or removing domains, establishing forest trusts, or raising forest functional levels. In a properly designed and implemented delegation model, EA membership is required only when first constructing the forest or when making certain forest-wide changes such as establishing an outbound forest trust.

The EA group is located by default in the Users container in the forest root domain, and it is a universal security group, unless the forest root domain is running in Windows 2000 Server mixed mode, in which case the group is a global security group. Although some rights are granted directly to the EA group, many of this group's rights are actually inherited by the EA group because it is a member of the Administrators group in each domain in the forest. Enterprise Admins have no default rights on workstations or member servers.


# Domain Admins
Each domain in a forest has its own Domain Admins (DA) group, which is a member of that domain's built-in Administrators (BA) group in addition to a member of the local Administrators group on every computer that is joined to the domain. The only default member of the DA group for a domain is the Built-in Administrator account for that domain.

DAs are all-powerful within their domains, while EAs have forest-wide privilege. In a properly designed and implemented delegation model, DA membership should be required only in "break glass" scenarios, which are situations in which an account with high levels of privilege on every computer in the domain is needed, or when certain domain wide changes must be made. Although native Active Directory delegation mechanisms do allow delegation to the extent that it is possible to use DA accounts only in emergency scenarios, constructing an effective delegation model can be time consuming, and many organizations use third-party applications to expedite the process.

The DA group is a global security group located in the Users container for the domain. There is one DA group for each domain in the forest, and the only default member of a DA group is the domain's Built-in Administrator account. Because a domain's DA group is nested in the domain's BA group and every domain-joined system's local Administrators group, DAs not only have permissions that are specifically granted to Domain Admins, but they also inherit all rights and permissions granted to the domain's Administrators group and the local Administrators group on all systems joined to the domain.

# Powereye user requirements
1. Global local administrator
2. read from AD
3. delegation to reset password, change security groups on most users