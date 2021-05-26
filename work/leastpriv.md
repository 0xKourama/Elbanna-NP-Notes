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