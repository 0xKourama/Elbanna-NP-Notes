# general learning notes
1. create the overall model with a diagram or map
2. grab the ideas from each sentence
3. make sure you understand the purpose of every:
	1. object
	2. operation
	3. idea
4. rephrase each sentence
	*changing it into your own words helps a lot*
5. recap what you have learned making sure you get the ideas in your words before you sleep
6. before the interview ... compress everything (clustering and mind mapping)

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

## Kerberos:
### Kerberos flow:
1. 


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
- DC that is the primary route for replication traffic moving in/out of sites
- more than one domain = more than one bridgehead
- authoritative for the partitions (naming contexts) that is holds in it's local domain
	- what does authoritative mean?
- even if DC is a GC and has a copy of other domains NCs, he isn't authoritative for these partial domain NCs
- multiple domains = multiplce DCs = multiple bridge heads that are authoritative for their domains
- How does a DC become a bridgehead server?
	- KCC elects bridgehead, it evaluates DCs in each site to determine whether they can be bridgehead servers
	- the KCC attempts to establish the minimum number of DCs necessary to replicate the three NCs between its site and any connected sites
	- If more than one DC is eligible for the role of bridgehead server:
		- the KCC sorts the DCs by their globally unique identifiers (GUIDs) and elects the server that has the lowest GUID
	- You can also designate certain DCs as preferred so that the KCC focuses on those servers when making its selection.
		[!] However, be aware that such manual designation affects the KCC's failover capabilities.
	- If you let the KCC automatically select the bridgehead server:
		- the KCC is free to recover from a failure of that server and identify a replacement
	- If you designate preferred bridgehead servers:
		- the KCC can use only the servers that you designated. 
	- Therefore:
		- if you designate only one DC as preferred:
			- and that server goes offline:
				- the KCC can't come to your rescue
	- if you decide to manually identify preferred bridgehead servers:
		[+] make sure you identify a minimum of two for each NC in each site
- You can use the Microsoft Management Console (MMC) Active Directory Sites and Services snap-in to designate preferred bridgehead servers
	- Open the snap-in and navigate to the DC for which you want to make this designation
		- Right-click the DC object and choose Properties
			- Select the transport protocol (either RPC over IP or SMTP) for which this DC will be preferred, then click Add
	- If you're using multiple transport protocols and you want to designate preferred bridgehead servers for a site:
		- you must designate at least one server for each of the transports


# what have I learned?
- replication happens for each partition/naming context
- each bridgehead server is authoritative for the partitions in it's domain
- the KCC automatically evaluates which server can be the bridge head for 
# what the new relationships/connections made?
# what are the relevant searches/definitions that need to be made?

# type of data found in the configuration partition

# get-acl of any object in AD

# removing legacy components


# overall 
go into microsoft documentation and smash it


he prefers theoretical than practical

GERMANY NIGGA!!!!!!!!!


# Skillset          SMB       MEDIUM      LARGE         ENTERPRISE
1. Google search    LOW       MEDIUM      HIGH          OFFICIAL DOC
2. english          LOW        LOW       MED-HIGH       PROFICIENT
3. analysis         NONE       LOW       MED-HIGH       MANDATORY
4. scripting        NONE       NONE      LOW-MED        HIGH
5. focus            NONE       LOW       MEDIUM         VERY HIGH
6. organization     NONE       LOW       MED-HIGH       VERY HIGH
7. process

# Active directory recycle bin
deletion is common
before 2008 r2 --> recovery had drawbacks
2008 -> auth restore -> make sure data is replicated to entire domain


# replication in depth
AD uses several counters and tables to ensure that every DC has the most current information for each attribute and object and to prevent any endless replication loops.
AD uses naming contexts (NCs), also known as directory partitions, to segment replication.
Every forest has a minimum of three NCs: the domain NC, the configuration NC, and the schema NC.
AD also supports special NCs, often known as application partitions or non-domain naming contexts (NDNCs).
DNS uses NDNCs (e.g., DomainDnsZones, ForestDnsZones).
Each NC or NDNC replicates independently of one another.

Every DC maintains a special counter known as an update sequence number (USN) counter.
The USN is a 64-bit number that you can think of like a clock.
The USN counter is never decremented, and a USN can never be reused.
Each DC maintains a separate USN counter that starts during the Dcpromo process and is incremented over the lifetime of a DC.
It’s improbable that any two DCs in a forest will ever have the exact same USN at the same time.
The USN counter is incremented each time a transaction occurs on a DC.
Transactions are typically create, update, or delete operations against an object.
An update transaction might include updates to a single attribute, or it might include updates to many attributes.
In the event that a transaction fails and is rolled back, the USN assigned to the transaction isn’t reused.
When an object is modified (or created), the usnChanged attribute of that object is stamped with the USN of the transaction that caused the change.
You can therefore keep track of changes to AD by asking a DC for all the objects for which the usnChanged attribute is greater than the highest USN the last time you checked.

Table 1 illustrates a simple example of the changes to the USNs of two DCs over time.
Consider a scenario in which you create five new groups on DC-A.
This action will increment DC-A’s USN counter by five.
DC-A then replicates these groups to DC-B, whose USN counter is incremented by five.
(Note that the initial USN values in Table 1 were chosen for illustration purposes.) Subsequently, you edit the name of one of the groups on DC-B.
DC-B’s USN counter is incremented by one.
When the change in name replicates to DC-A, DC-A’s USN counter is incremented by one.

From the perspective of DC-A, when the five groups are created, this is considered to be an originating write.
From the perspective of DC-B, this is a replicated write.
Conversely, when a group’s name is updated on DC-B, DC-B considers this action an originated write and DC-A considers it a replicated write.

The AD replication process identifies all the DCs participating in the replication process using two globally unique identifiers (GUIDs).
The first GUID, the Directory Service Agent (DSA) GUID, is established during Dcpromo and doesn’t change for the lifetime of the DC.
The DSA GUID is stored in the objectGuid attribute of the NTDS Settings object under the DC as shown in Active Directory Sites and Services.
The second GUID, the Invocation ID, is the identifier for the DC during the replication process; it might change during the DC’s lifetime.

The Invocation ID is stored in the invocationId attribute of the NTDS Settings object.
Any time a restore is performed on a DC by a supported restoration process, such as Windows Server Backup or NTBACKUP, that DC’s Invocation ID is reset.
By resetting the Invocation ID, AD is able to ensure that the DC receives a copy of any changes that occurred on that DC between when the backup was taken and when the restore was performed.
Because the Invocation ID is the unique identifier for the DC during the replication process, the reset of the Invocation ID effectively ensures that the DC enters the replication process as a new DC and there are no assumptions about data that might already exist on that DC.
Improper restoration of a virtualized DC, such as restoring or reverting back to a saved snapshot, won’t reset the DC’s invocation ID.
This leads to a situation known as USN rollback, which can cause severe replication problems.


Now that we’ve discussed how replication keeps track of DCs and changes, we can take a look at how replication determines what changes need to be replicated to a given DC and how replication ensures that changes aren’t unnecessarily replicated.
Two tables are used for this process: the High-Watermark Vector (HWMV) and the Up-To-Dateness Vector (UTDV).
The HWMV is maintained independently by each DC to keep track of where it left off (in terms of the last USN) replicating an NC with a given partner.
The UTDV is used by DCs to ensure that they don’t create needless replication or a loop.
When DC-A sends DC-B a request for replication, it includes its UTDV so that DC-B sends only changes that DC-A hasn’t received (e.g., in the case of changes made on DC-B that were replicated to DC-C and in turn to DC-A).

The UTDV stores the highest originating update USN that the DC has received from every other DC replicating a given NC.
By storing this information, DCs will never be sent changes that they’ve already received via another path (e.g., if a change occurs on DC-A, but DC-C receives it via DC-B).
This behavior is often referred to as propagation dampening.
Using the UTDV, the DC sending the information is able to determine changes it hasn’t sent to the DC that’s requesting replication, but also not send changes the DC has already received from other DCs.
This behavior prevents an endless loop of changes being replicated between DCs.

To summarize this process, each DC maintains an independent, forward-moving counter known as a USN counter.
The USN counter on a DC is incremented each time that DC performs an originating write (such as a create, delete, or update) to the directory.
When DCs replicate, they ask for all the changes since the previous USN they replicated from that DC.
This previous USN is stored in the HWMV so that DCs don’t ask for changes they’ve already received.
Inside each replication request, DCs also include their UTDV.
Each DC maintains a UTDV for each NC replicated, and inside the UTDV the DC tracks the highest originating update USN for which it has received changes, for every DC replicating the NC.
This prevents endless replication loops and leads to the behavior known as propagation dampening, which ensures that updates aren’t needlessly replicated.

