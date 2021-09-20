# what does active directory do?
1. stores info about objects on the network
2. makes this info available to users and network admins
3. uses domain controllers to give network users access to permitted resources anywhere on the network through single logon process

# what are the best practices for kerberos TGS & TGT?
- 10 hours

# what are the AD database, log files and SYSVOL locations?
1. Database: C:\Windows\NTDS
2. Log files: C:\Windows\NTDS
3. SYSVOL: C:\Windows\SYSVOL

# what is sysvol?
1. contains group policy objects
2. contains logon scripts
3. replicated by FRS

# what are AD replication components/objects?
1. Connection object
2. KCC
3. Failover functionality
4. Subnet
5. Site
6. Site link
7. Site link bridge
8. Site link transitivity
9. Global catalog server
10. Universal group membership caching

*Problems with replication can lead to authentication problems and problems with accessing resources on the network.*

# what are mixed and native modes?


# group policy processing order
1. local
2. site
3. domain
4. OU
*LSDO*

# what type of DB does AD use?
- ESE (Extensible storage engine)
- ISAM (Indexed Sequential Access Method)
This database file can reach up to 16 terabytes and contain more
*check ntds.dit on WP AD*

# what does net logon service do?
# What Is Dns Scavenging?
# what is an subdomain?
# what's the architecture in VF?
# what's the situation there?
# What Is New In Windows Server 2008 Active Directory Domain Services?
AD Domain Services auditing, Fine-Grained Password Policies,Read-Only Domain Controllers,Restartable Active Directory Domain Services
# What Is The Number Of Permitted Unsuccessful Log Ons On Administrator Account?
Unlimited. Remember, though, that it’s the Administrator account, not any account that’s part of the Administrators group.
# infrastructure master and GC?
# What Hidden Shares Exist On Windows Server 2003 Installation?
Admin$, Drive$, IPC$, NETLOGON, print$ and SYSVOL.


Pls clarify this why GC and Infrastructure master not placed in same DC?
Because Infrastructure master performs its task by comparing its state against the state of a GC. and updates other DCs in the same domain based on the outcome. Effectively, the update would never took place since no differences would be detected

# benefits of RODC
- Reduced security risk to a writable copy of Active Directory.
- Better logon times compared to authenticating across a WAN link.
- Better access to the authentication resource on the network.
- Better performance of directory-enabled applications.

# max clock skew of kerberos
300 seconds or 5 minutes

# commands to test health?
repadmin /showrepl
dcdiag

------------------------------------------------------------------------------

active directory as a service:
read more .. in different aspects
replication

# KCC & troubleshooting replication issues

# NTLM vs kerberos
## NTLM:
1. fallback for kerberos failure
2. challenge/response mechanism
### NTLM flow:
1. Client -- user requests acces -> server
2. Server -- sends challenge message -> client
3. Client -- sends response message -> server
4. Server -- sends challenge and response -> DC
5. DC     -- compares challenge and response to authenticate user -> Server
6. Server -- sends response to client --> client

1. A user accesses a client computer and provides a domain name, user name, and a password.
The client computes a cryptographic hash of the password and discards the actual password. The client sends the user name to the server (in plaintext).
2. The server generates a 16-byte random number, called a challenge, and sends it back to the client.
3. The client encrypts this challenge with the hash of the user's password and returns the result to the server. This is called the response.
4. The server sends the following three items to the domain controller:
- User Name
- Challenge sent to the client
- Response received from the client
5. The domain controller uses the user name to retrieve the hash of the user's password. It compares the encrypted challenge with the response by the client (in step 4). If they are identical, authentication is successful, and the domain controller notifies the server.
6. The server then sends the appropriated response back to the client.


# infrastructure master and global catalog


# encryption RC4 vs AES

# group policies and processing order
LSDOU
when computer vs user.-> computer wins

# active directory partitions
1. schema partition
2. configuration partition
3. domain partition

# duration of inter-site and intra-site replication

# difference between security and distribution group


# bridge head server

# type of data found in the configuration partition

# get-acl of any object in AD

# removing legacy components


# overall 
go into microsoft documentation and smash it


he prefers theoretical than practical

GERMANY NIGGA!!!!!!!!!