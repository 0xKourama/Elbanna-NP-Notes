# Administrators
1. Access this computer from the network
2. Adjust memory quotas for a process
3. Allow log on locally
4. Allow log on through Terminal Services
5. `Back up files and directories`
6. Bypass traverse checking
7. Change the system time
8. Create a pagefile
9. `Debug programs`
10. Force shutdown from a remote system
11. Increase scheduling priority
12. `Load and unload device drivers`
13. Manage auditing and security log
14. Modify firmware environment variables
15. Perform volume maintenance tasks
16. Profile single process
17. Profile system performance
18. Remove computer from docking station
19. `Restore files and directories`
20. Shut down the system
21. `Take ownership of files or other objects`

# Backup Operators
1. Access this computer from the network
2. Allow log on locally
3. `Back up files and directories`
4. Bypass traverse checking
5. `Restore files and directories`
6. Shut down the system

# Power Users
1. Access this computer from the network
2. Allow log on locally
3. Bypass traverse checking
4. Change the system time
5. Profile single process
6. Remove computer from docking station
7. Shut down the system

# Server Operators
1. Allow log on locally
2. `Back up files and directories`
3. Change the system time
4. Change the time zone
5. Force shutdown from a remote system
6. `Restore files and directories`
7. Shut down the system

# Remote Desktop Users
1. Allow log on through Terminal Services

# Users
1. Access this computer from the network
2. Allow log on locally
3. Bypass traverse checking

# Network Configuration Operators
1. Members of this group can make changes to TCP/IP settings and renew and release TCP/IP addresses. This group has no default members.

# Performance Monitor Users
1. Members of this group can monitor performance counters on the server locally and from remote clients without being a member of the Administrators or Performance Log Users groups.

# Event Log Readers
1. Members of this group can read event logs from local machine

# Remote Management Users
1. Members of this group can access WMI resources over management protocols (such as WS-Management via the Windows Remote Management service). This applies only to WMI namespaces that grant access to the user.

---

# Exploitable privileges:
SeAssignPrimaryToken: Replace a process level token
SeBackup: Back up files and directories
SeCreateToken: Create a token object
SeDebug: Debug programs
SeLoadDriver: Load and unload device drivers
SeRestore: Restore files and directories
SeTakeOwnership: Take ownership of files or other objects
SeTcb: Act as part of the operating system