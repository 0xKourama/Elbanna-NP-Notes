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
*LSDOU*

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

# bridgehead server
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


# Global catalog
# The global catalog is a feature of Active Directory (“AD”) domain controllers that allows for a domain controller to provide information on any object in the forest:
- regardless of whether the object is a member of the domain controller’s domain.

## A global catalog server is a domain controller that stores information about all objects in the forest,
- so that applications *CAN* search AD DS without referring to specific domain controllers that store the requested data.
## Like all domain controllers,
- a global catalog server stores full,
- writable replicas of the schema *AND* configuration directory partitions *AND* a full,
- writable replica of the domain directory partition for the domain that it is hosting.
## In addition,
- a global catalog server stores a partial,
- read- *ONLY* replica of every other domain in the forest.
## Partial,
- read- *ONLY* domain replicas contain every object in the domain *BUT* *ONLY* a subset of the attributes (those attributes that are most comm *ONLY* used for searching the object).

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Determining Changes to Replicate: Update Sequence Numbers

## A source domain controller uses USNs to determine what changes have already been received *BY* a destination domain controller that is requesting changes.
## The destination domain controller uses USNs to determine what changes it needs to request.

## The current USN is a 64-bit counter that is maintained *BY* each Active Directory domain controller as the highestCommittedUsnattribute on the rootDSE object.
## At the start of each update transaction (originating *OR* replicated),
- the domain controller increments its current USN *AND* associates this new value with the update request.

## Note

## The rootDSE (DSA-specific Entry) represents the top of the logical namespace for one domain controller.
## RootDSE has no hierarchical name *OR* schema class,
- *BUT* it does have a set of attributes that identify the contents of a given domain controller.
## The current USN value is stored on an updated object as follows:

## Local USN: The USN for the update is stored in the metadata of each attribute that is changed *BY* the update as the local USN of that attribute (originating *AND* replicated writes).
## As the name implies,
- this value is local to the domain controller where the change occurs.

## uSNChanged: The maximum local USN among *ALL* of an object’s attributes is stored as the object’s uSNChangedattribute (originating *AND* replicated writes).
## The uSNChangedattribute is indexed,
- *WHICH* allows objects to be enumerated efficiently in the order of their most recent attribute write.

## Note

## *WHEN* the forest functional level is Windows Server 2003 *OR* Windows Server 2003 interim,
- discrete values of linked multivalued attributes *CAN* be updated individually.
## In this case,
- there is a uSNChangedassociated with each link in addition to the uSNChangedassociated with each object.
## *THEREFORE*,
- updates to individual values of linked multivalued attributes do *NOT* affect the local USN,
- *ONLY* the uSNChangedattribute on the object.
## Originating USN: For an originating write only,
- the update’s USN value is stored with each updated attribute as the originating USN of that attribute.
## Unlike the local USN *AND* uSNChanged,
- the originating USN is replicated with the attribute’s value.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Universal group membership caching

## Universal group membership caching allows the domain controller to cache universal group membership information for users.
## You *CAN* enable domain controllers that are running Windows Server 2008 to cache universal group memberships *BY* using the Active Directory Sites *AND* Services snap-in.

## Enabling universal group membership caching eliminates the need for a global catalog server at every site in a domain,
- *WHICH* minimizes network bandwidth usage because a domain controller does *NOT* need to replicate all of the objects located in the forest.
## It also reduces logon times because the authenticating domain controllers do *NOT* *ALWAYS* need to access a global catalog to obtain universal group membership information.
## For more information about *WHEN* to use universal group membership caching,
- see Planning Global Catalog Server Placement.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# failover functionality

## Sites ensure that replication is routed around network failures *AND* offline domain controllers.
## The KCC runs at specified intervals to adjust the replication topology for changes that occur in AD DS,
- such as *WHEN* new domain controllers are added *AND* new sites are created.
## The KCC reviews the replication status of existing connections to determine *IF* any connections are *NOT* working.
## *IF* a connection is *NOT* working due to a failed domain controller,
- the KCC automatically builds temporary connections to other replication partners (*IF* available) to ensure that replication occurs.
## *IF* all the domain controllers in a site are unavailable,
- the KCC automatically creates replication connections <-- *BETWEEN* --> domain controllers from another site.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# KCC

## The KCC is a built-in process that runs on all domain controllers *AND* generates replication topology for the Active Directory forest.
## The KCC creates separate replication topologies depending on whether replication is occurring within a site (intrasite) *OR* <-- *BETWEEN* --> sites (intersite).
## The KCC also dynamically adjusts the topology to accommodate the addition of new domain controllers,
- the removal of existing domain controllers,
- the movement of domain controllers to *AND* from sites,
- changing costs *AND* schedules,
- *AND* domain controllers that are temporarily unavailable *OR* in an error state.

## Within a site,
- the connections <-- *BETWEEN* --> writable domain controllers are *ALWAYS* arranged in a bidirectional ring,
- with additional shortcut connections to reduce latency in large sites.
## On the other hand,
- the intersite topology is a layering of spanning trees,
- *WHICH* means one intersite connection exists <-- *BETWEEN* --> any two sites for each directory partition *AND* generally does *NOT* contain shortcut connections.
## For more information about spanning trees *AND* Active Directory replication topology,
- see Active Directory Replication Topology Technical Reference (https://go.microsoft.com/fwlink/?LinkID=93578).

## On each domain controller,
- the KCC creates replication routes *BY* creating one-way inbound connection objects that define connections from other domain controllers.
## For domain controllers in the same site,
- the KCC creates connection objects automatically without administrative intervention.
## *WHEN* you have more than one site,
- you configure site links <-- *BETWEEN* --> sites,
- *AND* a single KCC in each site automatically creates connections <-- *BETWEEN* --> sites as well.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Active Directory Replication Model Architecture

## Active Directory replication operates within the directory service component of the security subsystem.
## The directory service component,
- Ntdsa.dll,
- is accessed through the Lightweight Directory Access Protocol (LDAP) network protocol *AND* LDAP C application programming interface (API) for directory service updates,
- as implemented in Wldap32.dll.
## The updates are transported over Internet Protocol (IP) as packaged *BY* the replication remote procedure call (RPC) protocol.
## Simple Mail Transfer Protocol (SMTP) *CAN* also be used to prepare non-domain updates for Transmission Control Protocol (TCP) transport over IP.

## The Directory Replication System (DRS) client *AND* server components interact to transfer *AND* apply Active Directory updates <-- *BETWEEN* --> domain controllers.

## *WHEN* SMTP is used for the replication transport,
- Ismserv.exe on the source domain controller uses the Collaborative Data Object (CDO) library to build an SMTP file on disk with the replication data as the attached mail message.
## The message file is placed in a queue directory.
## *WHEN* the mail is scheduled for transfer *BY* the mail server application,
- the SMTP service (Smtpsvc) delivers the mail message to the destination domain controller over TCP/IP *AND* places the file in the drop directory on the destination domain controller.
## Ismserv.exe applies the updates on the destination.

## The following diagram shows the client-server architecture for replication clients *AND* LDAP clients.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc772726(v=ws.10)




# Domain controllers with the global catalog feature enabled are referred to as global catalog servers AND can perform several functions that are especially important in a multi-domain forest environment:

# Authentication.
# During an interactive domain logon:
- a domain controller will process the authentication request *AND* provide authorization information regarding all of the groups of which the user account is a member for inclusion in the generated user access token.

# User Principal Name Resolution.
# Logon requests made using a user principal name (e.g.:
- “username@domain.com”) require a search of the global catalog to identify the user account containing a matching userPrincipalName value.
# This search is used to identify the distinguished name of the associated user object so the authentication request can be forwarded to a domain controller in the user object’s domain.

# Universal Group Membership.
# Logon requests made in multi-domain environments require the use of a global catalog that can check for the existence of any universal groups *AND* determine if the user logging on is a member of any of those groups.
# Because the global catalog is the only source of universal groups membership information:
- access to a global catalog server is a requirement for authentication in a multidomain forest.

# Object Search.
# The global catalog makes the directory structure within a forest transparent to users who perform a search.
# For example:
- any global catalog server in a forest is capable of identifying a user object given only the object’s samAccountName.
# Without a global catalog server:
- identifying a user object given only its samAccountName could require separate searches of every domain in the forest.

# Active Directory Partitions
# To understand how the global catalog works:
- it is important to first understand a little bit about how the Active Directory database is structured.

# Domain controllers store the Active Directory database in a single file:
- NTDS.dit.
# To simplify administration *AND* facilitate efficient replication:
- the database itself is logically separated into partitions.

# Every domain controller maintains at least three partitions:

# The domain partition contains information about a domain’s objects *AND* their attributes.
# Every domain controller contains a complete writable replica of its local domain partition.
# The configuration partition contains information about the forest’s topology:
- including domain controllers *AND* site links.
# Every domain controller in a forest maintains a complete writable replica of the configuration partition.
# The schema partition is a logical extension of the configuration partition *AND* contains definitions of every object class in the forest *AND* the rules that control the creation *AND* manipulation of those objects.
# Every domain controller in a forest maintains a complete replica of the schema partition.
# The schema partition is read-only on every domain controller except the domain controller that owns the Schema Master operations role for the forest.

# Domain controllers may also maintain application partitions.
# These partitions contain information relating to AD-integrated applications (e.g.:
- AD-integrated DNS stores information in two application partitions:
- DomainDNSZones *AND* ForestDNSZones) *AND* can contain any type of object except for security principals.
# Application partitions have no specific replication requirements --> they are not required to replicate to other domain controllers *BUT* can be configured to replicate to any domain controller in a forest.

# As the graphic illustrates:
- each domain controller maintains a replica of its local domain partition:
- the configuration partition:
- *AND* the schema partition.
# In a multi-domain forest like the one shown above:
- global catalog servers also host an additional set of read-only partitions.
# Each of these partitions contains a partial:
- read-only replica of the domain partition from one of the other domains in the forest.

# It is the information in these partial:
- read-only partitions that allow global catalog servers to function as a reliable central repository of domain information.
# As a result:
- domain controllers that have been configured as global catalog servers are used to process authentication *AND* forest-wide search requests in a multi-domain forest.

# The subset of object attributes that are replicated to global catalog servers is called the Partial Attribute Set (“PAS”).
# The members of the Partial Attribute Set in a domain can be listed using the Get-ADObject PowerShell cmdlet:

# In a single-domain forest:
- all domain controllers host the only domain partition in the forest and:
- consequently:
- contain a record of all of the objects in the forest.
# This results in all domain controllers in a single-domain forest being capable of processing authentication *AND* domain service requests.

# Active Directory takes advantage of this by allowing any domain controller in a single-domain forest to function as a virtual global catalog server:
- regardless of whether it has been configured as a global catalog server.
# The only limitation to the virtual global catalog behavior is that only domain controllers configured as global catalog servers can respond to queries directed specifically to a global catalog.



# Deploying Global Catalog Servers
# When a new domain is created the first domain controller will be made a global catalog server.
# Additional domain controllers can be configured as a global catalog by enabling the Global Catalog checkbox in the Server’s NTDS Settings properties in the Active Directory Sites *AND* Services management console *OR* the Set-ADObject PowerShell cmdlet:

# Set-ADObject -Identity (Get-ADDomainController -Server <SERVER>).NTDSSettingsObjectDN -Replace @{options='1'} 

# Each site in the forest should contain at least one global catalog server to eliminate the need for an authenticating domain controller to communicate across the network to retrieve global catalog information.

# In situations where it is not feasible to deploy a global catalog server in a site:
- such as a small remote branch office:
- Universal Group Membership Caching can reduce authentication-related network traffic across a network *AND* allow for logon authentication even when communication with a global catalog server is inaccessible from within the remote site.

# Enabling Universal Group Membership Caching allows for the remote site’s domain controller to process local site login requests using cached universal group membership information.
# When an initial logon occurs:
- the site’s domain controller passes the authentication request through to a global catalog server *AND* caches the response for use in processing subsequent login attempts.
# This feature still requires communication with a global catalog server to process initial logons within the site *AND* perform search requests.

# In any case:
- it is recommended that all domain controllers be configured as global catalog servers unless there is a specific reason to avoid doing so.


# A global catalog is a multi-domain catalog that allows for faster searching of objects without the need for a domain name.
# It helps in locating an object from any domain by using its partial:
- read-only replica stored in a domain controller.
# As it uses only partial information *AND* a set of attributes that are most commonly used for searching:
- the objects from all domains:
- even in a large forest:
- can be represented by a single database of a global catalog server.

# A global catalog is created *AND* maintained by the AD DS replication system.
# The predefined attributes that are copied into a global catalog are known as the Partial Attribute Set (PAS).
# Users are allowed to add *OR* delete the attributes stored in a global catalog *AND* thus change the database schema.

# Some of the common global catalog usage scenarios are as follows:

# Forest-wide searches
# User logon
# Universal group membership caching
# Exchange address book lookups


----------------------------------------------------------------------------------

# NTLM vs KERB

# Windows New Technology LAN Manager (NTLM) is a suite of security protocols offered by Microsoft to authenticate users’ identity *AND* protect the integrity *AND* confidentiality of their activity.
# At its core:
- NTLM is a single sign on (SSO) tool that relies on a challenge-response protocol to confirm the user without requiring them to submit a password.

------

# challenge reponse:
# In computer security:
- challenge–response authentication is a family of protocols in which one party presents a question ("challenge") *AND* another party must provide a valid answer ("response") to be authenticated.[1]

# The simplest example of a challenge–response protocol is password authentication:
- where the challenge is asking for the password *AND* the valid response is the correct password.

# Clearly an adversary who can eavesdrop on a password authentication can then authenticate itself in the same way.
# One solution is to issue multiple passwords:
- each of them marked with an identifier.
# The verifier can ask for any of the passwords:
- *AND* the prover must have that correct password for that identifier.
# Assuming that the passwords are chosen independently:
- an adversary who intercepts one challenge–response message pair has no clues to help with a different challenge at a different time.

------

# Despite known vulnerabilities:
- NTLM remains widely deployed even on new systems in order to maintain compatibility with legacy clients *AND* servers.
# While NTLM is still supported by Microsoft:
- it has been replaced by Kerberos as the default authentication protocol in Windows 2000 *AND* subsequent Active Directory (AD) domains.

# How Does the NTLM Protocol Work?
## NTLM authenticates users through a challenge-response mechanism.
## This process consists of three messages:

## Negotiation message from the client
## Challenge message from the server
## Authentication message from the client

# NTLM Authentication Process
## NTLM authentication typically follows the following step-by-step process:

## The user shares their username:
- password *AND* domain name with the client.
## The client develops a scrambled version of the password — *OR* hash — *AND* deletes the full password.
## The client passes a plain text version of the username to the relevant server.
## The server replies to the client with a challenge:
- which is a 16-byte random number.
## In response:
- the client sends the challenge encrypted by the hash of the user’s password.
## The server then sends the challenge:
- response *AND* username to the domain controller (DC).
## The DC retrieves the user’s password from the database *AND* uses it to encrypt the challenge.
## The DC then compares the encrypted challenge *AND* client response.
## If these two pieces match:
- then the user is authenticated *AND* access is granted

# The Difference Between NTLM and Kerberos?
## Like NTLM:
- Kerberos is an authentication protocol.
## It replaced NTLM as the default/standard authentication tool on Windows 2000 *AND* later releases.

## The main difference between NTLM *AND* Kerberos is in how the two protocols manage authentication.
## NTLM relies on a three-way handshake between the client *AND* server to authenticate a user.
## Kerberos uses a two-part process that leverages a ticket granting service *OR* key distribution center.

## Another main difference is whether passwords are hashed *OR* encrypted.
## NTLM relies on password hashing:
- which is a one-way function that produces a string of text based on an input file --> Kerberos leverages encryption:
- which is a two-way function that scrambles *AND* unlocks information using an encryption key *AND* decryption key respectively.

## Even though the Kerberos protocol is Microsoft’s default authentication method today:
- NTLM serves as a backup.
## If Kerberos fails to authenticate the user:
- the system will attempt to use NTLM instead.

# Why Was NTLM Replaced by Kerberos?
## NTLM was subject to several known security vulnerabilities related to password hashing *AND* salting.

## In NTLM:
- passwords stored on the server *AND* domain controller are not “salted” — meaning that a random string of characters is not added to the hashed password to further protect it from cracking techniques.
## This means that adversaries who possess a password hash do not need the underlying password to authenticate a session.
## As a result:
- systems were vulnerable to brute force attacks:
- which is when an attacker attempts to crack a password through multiple log-in attempts.
## If the user selects a weak *OR* common password:
- they are especially susceptible to such tactics.

## NTLM’s cryptography also fails to take advantage of new advances in algorithms *AND* encryption that significantly enhance security capabilities.

# Kerberos Protocol
## Kerberos was developed by researchers at the Massachusetts Institute of Technology (MIT) in the 1980s.
## The name is derived from the Greek mythological character Kerberos:
- the three-headed dog who guards the underworld.

## In practice:
- the three security components in the Kerberos protocol are represented as:

## A client seeking authentication
## A server the client wants to access
## The ticketing service *OR* key distribution center (KDC)

# Kerberos Authentication

## Here is the twelve-step process for Kerberos authentication:

## The user shares their username:
- password:
- *AND* domain name with the client.
## The client assembles a package — *OR* an authenticator — which contains all relevant information about the client:
- including the user name:
- date *AND* time.
## All information contained in the authenticator:
- aside from the user name:
- is encrypted with the user’s password.
## The client sends the encrypted authenticator to the KDC.
## The KDC checks the user name to establish the identity of the client.
## The KDC then checks the AD database for the user’s password.
## It then attempts to decrypt the authenticator with the password.
## If the KDC is able to decrypt the authenticator:
- the identity of the client is verified.
## Once the identity of the client is verified:
- the KDC creates a ticket *OR* session key:
- which is also encrypted *AND* sent to the client.
## The ticket *OR* session key is stored in the client’s Kerberos tray --> the ticket can be used to access the server for a set time period:
- which is typically 8 hours.
## If the client needs to access another server:
- it sends the original ticket to the KDC along with a request to access the new resource.
## The KDC decrypts the ticket with its key.
## (The client does not need to authenticate the user because the KDC can use the ticket to verify that the user’s identity has been confirmed previously).
## The KDC generates an updated ticket *OR* session key for the client to access the new shared resource.
## This ticket is also encrypted by the server’s key.
## The KDC then sends this ticket to the client.
## The client saves this new session key in its Kerberos tray:
- *AND* sends a copy to the server.
## The server uses its own password to decrypt the ticket.
## If the server successfully decrypts the session key:
- then the ticket is legitimate.
## The server will then open the ticket *AND* review the access control list (ACL) to determine if the client has the necessary permission to access the resource.

# Applications That Use NTLM
## NTLM was replaced as the default authentication protocol in Windows 2000 by Kerberos.
## However:
- NTLM is still maintained in all Windows systems for compatibility purposes between older clients *AND* servers.

## For example:
- computers still running Windows 95:
- Windows 98:
- *OR* Windows NT 4.0 will use the NTLM protocol for network authentication with a Windows 2000 domain.
## Meanwhile:
- computers running Windows 2000 will use NTLM when authenticating servers with Windows NT 4.0 *OR* earlier:
- as well as when accessing resources in Windows 2000 *OR* earlier domains.
## NTLM is also used to authenticate local logons with non-domain controllers.

# NTLM Benefits and Challenges
## NTLM is considered an outdated protocol.
## As such:
- its benefits — when compared to a more modern solution:
- such as Kerberos — are limited.
## Yet the original promise of NTLM remains true: Clients use password hashing to avoid sending unprotected passwords over the network.

## At this point there are several clear disadvantages to relying on NTLM authentication:

## Single authentication.
## NTLM is a single authentication method.
## It relies on a challenge-response protocol to establish the user.
## It does not support multifactor authentication (MFA):
- which is the process of using two *OR* more pieces of information to confirm the identity of the user.
## Security vulnerabilities.
## The relatively simplistic form of password hashing makes NTLM systems vulnerable to several modes of attacks:
- including pass-the-hash *AND* brute-force attacks.
## Outdated cryptography.
## NTLM does not leverage the latest advances in algorithmic thinking *OR* encryption to make passwords more secure.

# How Can You Protect Your Network Using NTLM?

## Given the known security risks associated with NTLM:
- CrowdStrike recommends that organizations try to reduce NTLM usage in their network as much as possible.

## For organizations still relying on NTLM for compatibility reasons:
- CrowdStrike offers the following recommendations to enhance security *AND* minimize risk.

## Enforce NTLM mitigations.
## To be fully protected from NTLM relay attacks:
- you will need to enable server signing *AND* EPA on all relevant servers.
## Patch! Make sure your systems are fully protected with the latest security updates from Microsoft.
## Use advanced techniques.
## Apply advanced NTLM relay detection *AND* prevention techniques similar to the ones disclosed by Preempt (now CrowdStrike) in our Black Hat 2019 talk.
## Identify weak variations.
## Some NTLM clients use weak NTLM variations (e.g.:
- don’t send a MIC).
## This puts your network at a greater risk of being vulnerable to NTLM relay.
## Monitor NTLM traffic in your network.
## Try to restrict insecure NTLM traffic.
## Get rid of clients sending LM responses *AND* set the Group Policy Object (GPO) network security: LAN Manager authentication level to refuse LM responses.


--------------------------------------------------------------------------------------------------------

# NTLM vs KERB P2

# Difference Between NTLM and Kerberos (With Table)

## The NTLM authentication process solely involves the client *AND* the IIS7 server.
## However:
- under the ticket-based Kerberos protocol:
- a trusted third party is also privy to this process of authentication.
## This seminal difference between the two is highlighted further by the other dissimilarities apparent in a comparative analysis.

# NTLM vs Kerberos

## The difference between NTLM *AND* Kerberos is that the former is a challenge-response based authentication protocol:
- while the latter is a ticket-based authentication protocol.
## NTLM refers to an authentication protocol that is used by the older Windows models that are not members of an Active Directory domain:
- while Kerberos is essentially a ticket-based authentication protocol used in the newer Windows models that are members of an Active Directory domain.


# What is NTLM?

## The NTLM protocol is a proprietary Windows authentication protocol that uses a challenge-response system to authenticate logins.
## The NTLM system was prevalent in the older Windows computers that are not members of an Active Directory domain.

## After the initiation of the authentication process by the client:
- a three-way handshake between the client *AND* the server commences.
## The process begins with the client sending a message specifying his *OR* her account name *AND* encryption capabilities.
## Consequently:
- the server responds with a 64-bit nonce.
## This response is termed as the challenge.
## The client’s response is composed of this value *AND* his *OR* her own password.

## The security offered by the NTLM is inferior to those provided by the newer versions of other authentication protocols.
## This authentication protocol does not use a tri-party procedure.
## As a result:
- it is deemed less secure.
## Moreover:
- smartcard logons:
- mutual authentication:
- delegation:
- etc.
## are not facilitated by this older protocol.

# What is Kerberos?

## Kerberos is a Window authentication protocol that is compatible with the latest models launched by the brand.
## It is a ticket-based protocol that is used by those Windows PCs that are already members of an Active Directory domain.
## The USP of this protocol is that it can effectively reduce the total number of passwords needed by a user to access the network to only one.

## This secure:
- sophisticated:
- *AND* advanced authentication protocol was designed at MIT.
## It has been accepted as the standard authentication protocol for all computers- right from the Windows 2000 model to other more recent models.
## Kerberos also includes several formidable specs like mutual authentication *AND* a smart card logon.

## The security assurance of the Kerberos protocol is unmatched.
## It uses a third party to authenticate logins.
## This ensures enhanced safety *AND* minimizes the vulnerability of confidential data.
## By operating through centralized data centers:
- Kerberos ensures further stability *AND* security.


# Main Differences Between NTLM and Kerberos

## The main difference between NTLM *AND* Kerberos is that NTLM is a challenge-response based Microsoft authentication protocol that is used in the older Windows models that are not members of an Active Directory domain:
- while Kerberos is a ticket-based authentication protocol used in the newer variants of the Windows model.
## Smart card logon through a two factor authentication protocol is supported by Kerberos.
## NTLM does not support a smart card logon.
## In terms of security:
- Kerberos has an edge over NTLM.
## NTLM is comparatively less secured than Kerberos.
## Mutual authentication feature is available with Kerberos.
## Contrarily:
- NTLM does not offer the user this mutual authentication feature.
## While Kerberos supports both delegation *AND* impersonation:
- NTLM only supports impersonation.
## The authentication process under the NTLM protocol involves the client *AND* the server.
## However:
- under the Kerberos protocol:
- a reliable third party is privy to the authentication process.
## The earlier Windows models use the NTLM protocol.
## This includes versions like Windows 95:
- Windows 98:
- NT 4.0:
- etc.
## The Kerberos protocol is preinstalled on the newer models like Microsoft Windows 2000:
- XP:
- *AND* other latest models.

# Conclusion

## Both the NTLM *AND* Kerberos protocols are based on the symmetric key cryptography strategy *AND* both are strong:
- pertinent authentication systems.
## The two may seem overwhelmingly similar to novice users:
- however:
- the difference between the two is quite conspicuous.

## NTLM is a challenge-response-based authentication protocol:
- while Kerberos is a ticket-based authentication protocol.
## The former is used mostly in the older Windows models.
## Although Windows has maintained backward compatibility with this protocol:
- its usage has significantly reduced over the years.

## This change is largely attributed to the development of the more secured *AND* sophisticated protocols like Kerberos.
## Kerberos offers enhanced features as well as an improved protective shield for the user.

## Thus:
- in a comparative choice between the two:
- the newer Kerberos protocol emerges univocally successful.
## It embodies some of the most coveted modern features that one can desire in an advanced authentication protocol.

--------------------------------------------------------------------------------------------------------

# NTLM vs KERB P3

# A thorough understanding of Windows' authentication methods will enable you to troubleshoot problems *AND* improve network security.


## If you're having problems logging in to a diverse *AND* properly secured network:
- the solution may be just a matter of allowing the proper ports *AND* protocols between the devices to authenticate.
## Before jumping into the ports *AND* protocols:
- however:
- it's important to understand the sequence of events that begin user authentication.

## The WinLogon process
## WinLogon's first phase is [Ctrl][Alt][Delete]:
- Windows' default Security Attention Sequence (SAS).
## This sequence signals to the operating system that someone is trying to log on.

## When SAS is initiated:
- all user mode applications pause until the security operation is completed *OR* cancelled.
## This suspension of user mode applications is a significant security feature.
## Keystroke loggers *OR* Trojan viruses are disabled *AND* prevented from recording keystrokes as users input their passwords.

## The WinLogon process is a part of the Local Security Authority (LSA) for the Windows operating system logon procedure.
## To complete this procedure:
- the OS authenticates the user's credentials with a logon server and:
- depending on the type of authentication:
- the logon could fail if the proper ports *AND* protocols between the client *AND* the server aren't open.

## NT LAN Manager (NTLM) is the default authentication scheme used by the WinLogon process --> it uses three ports between the client *AND* domain controller (DC):
## UDP 137 - UDP 137 (NetBIOS Name)
## UDP 138 - UDP 138 (NetBIOS Netlogon *AND* Browsing)
## 1024-65535/TCP - TCP 139 (NetBIOS Session)

## Logon authentications will succeed with these ports open between your clients and their domain controllers

## Windows' default authentication equals poor security
## By default:
- the authentication scheme on both Windows NT *AND* Windows 2000 machines is set to LAN Manager (LM):
- which transmits *AND* stores each user password hash using an extremely weak security algorithm.
## This makes it easy for hackers to crack passwords once this weak password hash is captured.

## Microsoft has upgraded its proprietary authentication scheme four times.
## The current authentication standard for communications between NT clients *AND* NT/Win2K servers is now NTLMv2.
## However:
- if you haven't changed the LMCompatabilityLevel variable under the following registry key on both NT/Win2K clients *AND* servers:
- by default you're still using the LM scheme—which greatly decreases the security of your entire network:
## HKEY_Local_Machine\System\CurrentControlSet\control\LSA

## Make sure that you're set to use only NTLMv2 *AND* that the Reg_Dword is set to at least Level 3.
## This forces the clients to send NTLMv2 authentication only.
## (For more information on this change:
- read Microsoft Knowledge Base article 147706.)

## After you make this change:
- you'll still need to force the system to remove the LM hash.
## Run Regedt32.exe *AND* go back to the same registry key.
## On the Edit menu:
- click Add Key:
- add the key NoLMHash:
- *AND* leave the class field empty.
## (For more information on this registry change:
- read Microsoft article 299656.)

## This new registry key will force both NT *AND* Win2K to remove the LM hash:
- which will reduce your vulnerability to password crackers.
## However:
- any registry changes you make won't take place until the user changes his *OR* her password *AND* a new hash is created

## Now that you've gotten rid of the LM hash *AND* your network is using NTLMv2 for client authentication:
- the next step for securing authentication traffic on Windows-based networks is upgrading your clients *AND* servers to take advantage of Kerberos:
- the latest Windows authentication scheme.

# What about Kerberos for NT?

## There is no such thing as "Kerberos for NT." If you're still running NT clients:
- you can install the Active Directory (AD) client *AND* make them Active Directory-aware:
- *BUT* not Kerberos-enabled.
## The AD client installs the Active Directory Service Interfaces (ADSI):
- provides site awareness to NT computers so they can find the nearest domain controller:
- *AND* enables NT to use Win2K's Dfs *AND* AD Windows Address Book.
## This doesn't change the method NT computers use for authentication.

## NT machines will use only NTLM to authenticate:
- regardless of whether they're communicating with NT *OR* Win2K servers.
## To allow your clients *AND* servers to communicate securely:
- make sure the proper ports are open *AND* verify that your clients *AND* servers are set to use NTLMv2.

--------------------------------------------------------------------------------------------------------

# PASS THE HASH ATTACK 1

# PASS THE HASH P1

## We’ve done a lot of blogging at the Metadata Era warning you about basic attacks against passwords.
## These can be mitigated by enforcing strong passwords:
- eliminating vendor defaults:
- *AND* enabling reasonable lockout settings in Active Directory.
## But don’t rest yet! Hackers have another password trick that’s much more difficult to defend against.

## Advanced password:
- *OR* more precisely:
- credential attacks are still very popular and:
- unfortunately:
- quite effective.
## Known generically as pass-the-hash *OR* PtH:
- these attacks are seen by some as more of an issue with older Windows systems.
 Somewhat true:
- *BUT* they’re still very much a menace: PtH is the subject of presentations at recent Black Hat conferences:
-  several white papers from Microsoft’s own Trustworthy Computing division:
- *AND* a security bulletin from the NSA (for what it’s worth!).

# What’s a Hash?

## Security researchers have known almost since the beginning of modern computing that storing plain-text passwords is a poor security practice.
## Instead:
- they came up with the idea of passing the plaintext string through a special 1-way encryption function to produce a hash.
## You can read more about hashes in Rob’s excellent posts on the subject.

## The key point is that in both Windows (and Linux systems too) the hashed password is stored instead of the readable password.
 If you think about this a little:
- the hash acts as a proxy for identity—if you can prove you have it:
- it’s your ticket in.

## In Windows:
- the NTLM authentication protocol involves exchanging messages to validate that users have the hash without actually sending the hash over the wire.
## This authentication technique is at the center of how Active Directory supports remote logins within a domain *AND* is also used for other Windows services:
- most significantly remote file access

## By the way:
- vulnerabilities in earlier implementations of NTLM—since corrected—have led some to believe that PtH attacks are a thing of the past.
## Not only is PtH still viable *BUT* the same idea—grabbing hashes from disk *OR* memory—can also be used against more sophisticated Kerboros authentication.

# Don’t Crack the Hash, Pass it

## Windows caches the hashed passwords in memory to implement Single Sign On *OR* SSO:
- which is an essential feature of Windows enterprise environments.
 So far:
- so good.

## For example:
- on my Varonis laptop:
- I logon once with my password:
- Windows hashes it *AND* stores the code—currently 128-bits in NTLMv2— in memory  so that when:
- say:
- I mount a remote directory  *OR* use other services where I need to prove my identity:
- I don’t have to re-enter my password— Windows instead uses the cached hash.

## And that is enough of an opening for hackers to exploit.
## We’ve seen other attacks:
- most significantly with RAM scrapers used on Point-of-Sale devices:
- where hackers use easily available software to peek into this memory.
 Not surprisingly there are toolkits out there that will let hackers grab the credentials from memory:
- *AND* log them in as that user—see SANS’ Why Crack When You Can Pass the Hash.

## And that’s one of the major benefits of SSO:
- so to speak:
- for hackers: they don’t have to crack the hashes:
- they just re-use *OR* pass them to an authenticating server!

# PtH: It’s a Feature, Not a Bug

## The assumption that this attack makes is that the cyber thief gains administrator-level permissions for a user’s machine.
## Any expert will tell you:
- that’s not necessarily difficult to pull off:
- as we’ve seen in the Target hack.

## In a typical exploit:
- the hacker will grab some hashes:
- log onto other servers:
- *AND* continue the process of stockpiling credentials.
## If they hit the jackpot—a domain controller *OR* SQL server—they may able to get the hashes of just about everyone.

## As an aside:
- we don’t know exactly how Snowden obtained employee logon credentials—social engineering likely played a part.
## But his admin-level access would have made PtH a very good choice to extract the credentials of those with a higher security clearance than him.

## Unfortunately:
- pass-the-hash is a feature of Windows! After all:
- the underlying NTLM authentication is effectively passing the hash to implement SSO:
- saving you from password entry fatigue.
## Hackers are just exploiting this feature for their own purposes.
## Not to be too hard on Windows:
- PtH is also an issue in Linux systems that implement Kerboros :
- where you have an equivalent pass-the-ticket *OR* PtT attack.

## Here’s the most important takeaway: you can’t prevent PtH:
- you can only mitigate *OR* greatly reduce the possibility of this attack occurring.

## Hold that thought *AND* we’ll take up PtH mitigation through smart configurations of Active Directory *AND* other services in the next post.

--------------------------------------------------------------------------------------------------------

# PASS THE HASH P2: PREVENTION:

## Last week:
- I attended a webinar that was intended to give IT attendees a snapshot of recent threats—a kind of hacker heads-up.
## For their representative case:
- the two sec gurus described a clever *AND* very targeted phishing attack.
## It led to an APT being secretly deposited in a DLL.
## Once the hackers were in:
- I was a little surprised to see they were probing memory for password hashes.

## Pass the Hash:
- *OR* PtH:
- I learned:
- was a standard hacker trick for gaining new identities.
## It makes sense.
## Hackers prefer to use credentials taken this way *AND* logon directly as an existing user.
## Without sophisticated monitoring in place:
- they’re less likely to be spotted in real-time *OR* even forensically afterwards when appearing as ordinary insiders.

# Beware of Local Admin

## As I mentioned last time:
- PtH assumes that an attacker has admin-level privileges on the machine they’ve first entered.
## The hash:
- which is kept in the memory space of a process with local admin permissions:
- is by itself not used to establish identity.
## Instead:
- it becomes part of a secret key for encrypting *AND* decrypting messages in a challenge-response protocol.

## In effect:
- you need just the hash code to take over the identity of another user.
## The hard part is getting local admin access.

## Unfortunately:
- this is not a major hurdle.
## On older Windows systems (pre-Vista):
- the local admin account is automatically created *AND* even worse:
- IT may have given each user machine the same admin password.

## Suppose a laptop is compromised through a phish-mail that deposits malware.
 The malware succeeds in a brute force assault on the local admin passwords.
## From this machine:
- the hackers can leapfrog to other devices *AND* servers:
- either through new credentials that’ve been scooped from memory by PtH toolkits *OR* by simply reusing the admin password.

*it may be an annoyance for admins, but UAC is a  good defense against PtH.*

## Thankfully:
- newer Windows OSes—Windows 7 *AND* 8—by default don’t create a local admin account.
## Even better:
- Microsoft added a new malware defense known as User Account Controls *OR* UAC:
- which requires explicit authorization for a user (or software) to gain elevated privileges.

## Admins know UAC through the Consent *OR* Credential prompts (see pic) that pop up when they do legitimate work.
## While they may find this somewhat inconvenient:
- it does go a long way towards preventing malware *AND* APTs from getting a critical foot hold.

## For organizations with older OSes:
- IT can enforce a policy of creating unique *AND* robust admin passwords for each user machine.
## It’s a low-effort remedy for preventing the hackers from easily guessing admin credentials *AND* then reusing hashes on other machines.
## One simple trick is to append the machine name (or variation of it) to the password.

# Stomp Out Local Network Logon Access

## Another powerful mitigation that works on both old *AND* new Windows OSes is to prevent ordinary *AND* local admin users from directly networking into other users’ machines.
## In an Active Directory environment:
- you’d do that by using the Group Policy Object (GPO) Editor to disable Remote Desktop Connections.
## You can read more about how to do this here.

## Quick summary: disable network *AND* remote interactive logon privileges *AND* then link users *AND* groups to these specific User Rights policies.

# And Just Limit Hashes

## The above measures take care of a large part *BUT* not all the entry points for PtH attacks.
 In the exploit that I opened this post up with the hackers used SQL injection techniques to hijack a database server that was already running with elevated privileges.
## Result: they were able to scoop up high-level hashes.

## The least privilege security principle now comes to the fore: don’t run services—SQL servers:
- *AND* other IT infrastructure—with domain *OR* enterprise level access rights.
## These permissions are far broader than what system tools *AND* services generally need to do the job:
- *AND* if the software is ever compromised:
- the shells *OR* commands that are spawned automatically run at elevated access.

## However:
- sometimes this may not be feasible:
- *AND* of course:
- there are always zero-day exploits waiting to happen.
## So the key idea now is to limit the “bad” hashes—typically domain administrators—from spreading throughout the network.
 Recall that with Single Sign On:
- the hash:
- even for DAs:
- is always deposited in memory when logging onto a machine.

## The rule is simple: only give domain administrators the right to access machines with equally high privilege levels—i.e.:
- domain controllers—and never allow the same accounts access to plain-old employee laptops *AND* desktops.
## You can always create a separate account for system admins for servicing user devices *BUT* with non-domain admin privileges.

## That way:
- if a hacker (or internal user) should ever get control of a machine:
- they’ll never get the “keys to the kingdom”—a domain administrator’s hash that just happens to be in memory at the time.

--------------------------------------------------------------------------------------------------------

## Replication of updates to Active Directory objects are transmitted between multiple domain controllers to keep replicas of directory partitions synchronized.
## Multiple domains are common in large organizations:
- as are multiple sites in disparate locations.
## In addition:
- domain controllers for the same domain are commonly placed in more than one site.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

## Therefore:
- replication must often occur both within sites *AND* between sites to keep domain *AND* forest data consistent among domain controllers that store the same directory partitions.
## Site objects can be configured to include a set of subnets that provide local area network (LAN) network speeds.
## As such:
- replication within sites generally occurs at high speeds between domain controllers that are on the same network segment.
## Similarly:
- site link objects can be configured to represent the wide area network (WAN) links that connect LANs.
## Replication between sites usually occurs over these WAN links:
- which might be costly in terms of bandwidth.
## To accommodate the differences in distance *AND* cost of replication within a site *AND* replication between sites:
- the intrasite replication topology is created to optimize speed:
- *AND* the intersite replication topology is created to minimize cost.

## The Knowledge Consistency Checker (KCC) is a distributed application that runs on every domain controller *AND* is responsible for creating the connections between domain controllers that collectively form the replication topology.
## The KCC uses Active Directory data to determine where (from what source domain controller to what destination domain controller) to create these connections.

### what makes this important?
### what are your questions?
### what are the ideas?
- the intrasite replication topology is created to optimize speed:
- *AND* the intersite replication topology is created to minimize cost.
- the KCC runs on every DC
- the connection of links form the replication topology
- KCC determines connection direction
### what are the terms and meanings?
- Site objects can be configured to include a set of subnets that provide local area network (LAN) network speeds.
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?
- replication must often occur both within sites *AND* between sites to keep domain *AND* forest data consistent among domain controllers that store the same directory partitions.

----------------------------------------------------

# Replication within and between sites:

## The KCC creates separate replication topologies to transfer Active Directory updates within a site *AND* between all configured sites in the forest.
## The connections that are used for replication within sites are created automatically with no additional configuration.
```
## Intrasite replication takes advantage of LAN network speeds by providing replication as soon as changes occur:
- without the overhead of data compression:
- thus maximizing CPU efficiency.
```
## Intrasite replication connections form a ring topology with extra shortcut connections where needed to decrease latency.
## The fast replication of updates within sites facilitates timely updates of domain data.
## In deployments where large datacenters constitute hub sites for the centralization of mission-critical operations:
- directory consistency is critical.

## Replication between sites is made possible by user-defined site *AND* site link objects that are created in Active Directory to represent the physical LAN *AND* WAN network infrastructure.
## When Active Directory sites *AND* site links are configured:
- the KCC creates an intersite topology so that replication flows between domain controllers across WAN links.
## Intersite replication occurs according to a site link schedule so that WAN usage can be controlled:
- *AND* is compressed to reduce network bandwidth requirements.
## Site link settings can be managed to optimize replication routing over WAN links.
## The connections that are created between sites form a spanning tree for each directory partition in the forest:
- merging where common directory partitions can be replicated over the same connection.

## In remote branch locations:
- replication of updates from the hub sites is optimized for network availability.
## Thus:
- because intrasite replication is optimized for speed:
- branch locations across WAN links can be assured of receiving data from hub sites that is up-to-date *AND* reliable --> *BUT* because intersite replication is scheduled:
- branch sites receive this replication only at intervals that are deemed appropriate *AND* cost-effective for remote operations.

### what makes this important?
### what are your questions?
### what are the ideas?
`Intersite replication occurs according to a site link schedule so that WAN usage can be controlled:- *AND* is compressed to reduce network bandwidth requirements.`
intrasite replication is seamless and quick ... intersite is calculated and scheduled
### what are the terms and meanings?
hub site, branch
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?
- merging where common directory partitions can be replicated over the same connection.

----------------------------------------------------

# Technologies Related to Active Directory Replication Topology

## File Replication Service
## File Replication service (FRS) is related to Active Directory replication because it requires the Active Directory replication topology.
## FRS is a multimaster replication service that is used to replicate files *AND* folders in the system volume (SYSVOL) shared folder on domain controllers *AND* in Distributed File System (DFS) shared folders.
## FRS works by detecting changes to files *AND* folders *AND* then replicating the updated files *AND* folders to other replica members:
- which are connected in a replication topology.

## FRS uses the replication topology that is generated by the KCC to replicate the SYSVOL files to all domain controllers in the domain.
## SYSVOL files are required by all domain controllers for Active Directory to function.
## For more information about FRS *AND* how it uses the Active Directory replication topology:
- see “FRS Technical Reference”.
## For more information about SYSVOL:
- see “Data Store Technical Reference.”

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# SMTP

## Simple Mail Transfer Protocol (SMTP) is a packaging protocol that can be used as an alternative to the remote procedure call (RPC) replication transport.
## SMTP can be used to transport nondomain replication over IP networks in mail-message format.
## Where networks are not fully routed:
- e-mail is sometimes the only transport method available.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Active Directory Replication Topology Dependencies

## Active Directory replication topology has the following dependencies:

## Routable IP infrastructure.
## The replication topology is dependent upon a routable IP infrastructure from which you can map IP subnet address ranges to site objects.
## This mapping generates the information that is used by client workstations to communicate with domain controllers that are close by:
- when there is a choice:
- rather than those that are located across WAN links.

## DNS.
## The Domain Name System (DNS) resolves DNS names to IP addresses.
## Active Directory replication topology requires that DNS is properly designed *AND* deployed so that domain controllers can correctly resolve the DNS names of replication partners.

## DNS also stores service (SRV) resource records that provide site affinity information to clients searching for domain controllers:
- including domain controllers that are searching for replication partners.
## Every domain controller registers these records so that they can be located according to site.

## Net Logon service.
## Net Logon is required for DNS registrations.

## RPC.
## Active Directory replication requires IP connectivity *AND* RPC to transfer updates between replication partners within sites.
## RPC is required for replication between two sites containing domain controllers in the same domain:
- *BUT* SMTP is an alternative where RPC cannot be used *AND* domain controllers for the same domain are all located in one site so that intersite replication of domain data is not required.

## Intersite Messaging.
## Intersite Messaging is required for SMTP intersite replication *AND* for site coverage calculations.
## If the forest functional level is Windows 2000:
- Intersite Messaging is also required for intersite topology generation.

## The following diagram shows the interaction of these technologies with the replication topology:
- which is indicated by the two-way connections between each set of domain controllers.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# How Active Directory Replication Topology Works

## Active Directory implements a replication topology that takes advantage of the network speeds within sites:
- which are ideally configured to be equivalent to local area network (LAN) connectivity (network speed of 10 megabits per second [Mbps] *OR* higher).
## The replication topology also minimizes the use of potentially slow *OR* expensive wide area network (WAN) links between sites.

## When you create a site object in Active Directory:
- you associate one *OR* more Internet Protocol (IP) subnets with the site.
## Each domain controller in a forest is associated with an Active Directory site.
## A client workstation is associated with a site according to its IP address --> that is:
- each IP address maps to one subnet:
- which in turn maps to one site.

## Active Directory uses sites to:

## Optimize replication for speed *AND* bandwidth consumption between domain controllers.

## Locate the closest domain controller for client logon:
- services:
- *AND* directory searches.

## Direct a Distributed File System (DFS) client to the server that is hosting the requested data within the site.

## Replicate the system volume (SYSVOL):
- a collection of folders in the file system that exists on each domain controller in a domain *AND* is required for implementation of Group Policy.

## The ideal environment for replication topology generation is a forest that has a forest functional level of at least Windows Server 2003.
## In this case:
- replication topology generation is faster *AND* can accommodate more sites *AND* domains than occurs when the forest has a forest functional level of Windows 2000.
## When at least one domain controller in each site is running Windows Server 2003:
- more domain controllers in each site can be used to replicate changes between sites than when all domain controllers are running Windows 2000 Server.

## In addition:
- replication topology generation requires the following conditions:

## A Domain Name System (DNS) infrastructure that manages the name resolution for domain controllers in the forest.
## Active Directory–integrated DNS is assumed:
- wherein DNS zone data is stored in Active Directory *AND* is replicated to all domain controllers that are DNS servers.

## All physical locations that are represented as site objects in Active Directory have LAN connectivity.

## IP connectivity is available between each site *AND* all sites in the same forest that host operations master roles.

## Domain controllers meet the hardware requirements for Windows Server 2008 R2:
- Windows Server 2008:
- Windows Server 2003:
- Standard Edition --> Windows Server 2003:
- Enterprise Edition --> *AND* Windows Server 2003:
- Datacenter Edition.

## The appropriate number of domain controllers is deployed for each domain that is represented in each site.

## This section covers the replication components that create the replication topology *AND* how they work together:
- plus the mechanisms *AND* rationale for routing replication traffic between domain controllers in the same site *AND* in different sites.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Active Directory KCC Architecture and Processes

## The replication topology is generated by the Knowledge Consistency Checker (KCC):
- a replication component that runs as an application on every domain controller *AND* communicates through the distributed Active Directory database.
## The KCC functions locally by reading:
- creating:
- *AND* deleting Active Directory data.
## Specifically:
- the KCC reads configuration data *AND* reads *AND* writes connection objects.
## The KCC also writes local:
- nonreplicated attribute values that indicate the replication partners from which to request replication.

## For most of its operation:
- the KCC that runs on one domain controller does not communicate directly with the KCC on any other domain controller.
## Rather:
- all KCCs use the knowledge of the common:
- global data that is stored in the configuration directory partition as input to the topology generation algorithm to converge on the same view of the replication topology.

## Each KCC uses its in-memory view of the topology to create inbound connections locally:
- manifesting only those results that apply to itself.
## The KCC communicates with other KCCs only to make a remote procedure call (RPC) request for replication error information.
## The KCC uses the error information to identify gaps in the replication topology.
## A request for replication error information occurs only between domain controllers in the same site.

## Note

## The KCC uses only RPC to communicate with the directory service.
## The KCC does not use Lightweight Directory Access Protocol (LDAP).
## One domain controller in each site is selected as the Intersite Topology Generator (ISTG).
## To enable replication across site links:
- the ISTG automatically designates one *OR* more servers to perform site-to-site replication.
## These servers are called bridgehead servers.
## A bridgehead is a point where a connection leaves *OR* enters a site.

## The ISTG creates a view of the replication topology for all sites:
- including existing connection objects between all domain controllers that are acting as bridgehead servers.
## The ISTG then creates inbound connection objects for servers in its site that it determines will act as bridgehead servers *AND* for which connection objects do not already exist.
## Thus:
- the scope of operation for the KCC is the local server only:
- *AND* the scope of operation for the ISTG is a single site.

## Each KCC has the following global knowledge about objects in the forest:
- which it gets by reading objects in the Sites container of the configuration directory partition *AND* which it uses to generate a view of the replication topology:

## Sites
## Servers
## Site affiliation of each server
## Global catalog servers
## Directory partitions stored by each server
## Site links
## Site link bridges

## Detailed information about these configuration components *AND* their functionality is provided later in this section.

## The following diagram shows the KCC architecture on servers in the same forest in two sites.

## KCC Architecture *AND* Processes

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# The architecture and process components in the preceding diagram are described in the following table.

## Knowledge Consistency Checker (KCC)
## The application running on each domain controller that communicates directly with the Ntdsa.dll to read *AND* write replication objects.

## Directory System Agent (DSA)
## The directory service component that runs as Ntdsa.dll on each domain controller:
- providing the interfaces through which services *AND* processes such as the KCC gain access to the directory database.

## Extensible Storage Engine (ESE)
## The directory service component that runs as Esent.dll.
## ESE manages the tables of records:
- each with one *OR* more columns.
## The tables of records comprise the directory database.

## Remote procedure call (RPC)
## The Directory Replication Service (Drsuapi) RPC protocol:
- used to communicate replication status *AND* topology to a domain controller.
## The KCC also uses this protocol to communicate with other KCCs to request error information when building the replication topology.

## Intersite Topology Generator (ISTG)
- The single KCC in a site that manages intersite connection objects for the site.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

## The four servers in the preceding diagram create identical views of the servers in their site *AND* generate connection objects on the basis of the current state of Active Directory data in the configuration directory partition.
## In addition to creating its view of the servers in its respective site:
- the KCC that operates as the ISTG in each site also creates a view of all servers in all sites in the forest.
## From this view:
- the ISTG determines the connections to create on the bridgehead servers in its own site.

## Note

## A connection requires two endpoints: one for the destination domain controller *AND* one for the source domain controller.
## Domain controllers creating an intrasite topology always use themselves as the destination end point *AND* must consider only the endpoint for the source domain controller.
## The ISTG:
- however:
- must identify both endpoints in order to create connection objects between two other servers.
## Thus:
- the KCC creates two types of topologies: intrasite *AND* intersite.
## Within a site:
- the KCC creates a ring topology by using all servers in the site.
## To create the intersite topology:
- the ISTG in each site uses a view of all bridgehead servers in all sites in the forest.
## The following diagram shows a high-level generalization of the view that the KCC sees of an intrasite ring topology *AND* the view that the ISTG sees of the intersite topology.
## Lines between domain controllers within a site represent inbound *AND* outbound connections between the servers.
## The lines between sites represent configured site links.
## Bridgehead servers are represented as BH.

### what makes this important?
### what are your questions?
### what are the ideas?
ISTG views tree of bridgeheads
KCC views bi-directional ring with shortcuts if a DC is more than 3 hops away
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Replication Topology Physical Structure

## The Active Directory replication topology can use many different components.
## Some components are required *AND* others are not required *BUT* are available for optimization.
## The following diagram illustrates most replication topology components *AND* their place in a sample Active Directory multisite *AND* multidomain forest.
## The depiction of the intersite topology that uses multiple bridgehead servers for each domain assumes that at least one domain controller in each site is running at least Windows Server 2003.
## All components of this diagram *AND* their interactions are explained in detail later in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

## In the preceding diagram:
- all servers are domain controllers.
## They independently use global knowledge of configuration data to generate one-way:
- inbound connection objects.
## The KCCs in a site collectively create an intrasite topology for all domain controllers in the site.
## The ISTGs from all sites collectively create an intersite topology.
## Within sites:
- one-way arrows indicate the inbound connections by which each domain controller replicates changes from its partner in the ring.
## For intersite replication:
- one-way arrows represent inbound connections that are created by the ISTG of each site from bridgehead servers (BH) for the same domain (or from a global catalog server [GC] acting as a bridgehead if the domain is not present in the site) in other sites that share a site link.
## Domains are indicated as D1:
- D2:
- D3:
- *AND* D4.

## Each site in the diagram represents a physical LAN in the network:
- *AND* each LAN is represented as a site object in Active Directory.
## Heavy solid lines between sites indicate WAN links over which two-way replication can occur:
- *AND* each WAN link is represented in Active Directory as a site link object.
## Site link objects allow connections to be created between bridgehead servers in each site that is connected by the site link.

## Not shown in the diagram is that where TCP/IP WAN links are available:
- replication between sites uses the RPC replication transport.
## RPC is always used within sites.
## The site link between Site A *AND* Site D uses the SMTP protocol for the replication transport to replicate the configuration *AND* schema directory partitions *AND* global catalog partial:
- read-only directory partitions.
## Although the SMTP transport cannot be used to replicate writable domain directory partitions:
- this transport is required because a TCP/IP connection is not available between Site A *AND* Site D.
## This configuration is acceptable for replication because Site D does not host domain controllers for any domains that must be replicated over the site link A-D.

## By default:
- site links A-B *AND* A-C are transitive (bridged):
- which means that replication of domain D2 is possible between Site B *AND* Site C:
- although no site link connects the two sites.
## The cost values on site links A-B *AND* A-C are site link settings that determine the routing preference for replication:
- which is based on the aggregated cost of available site links.
## The cost of a direct connection between Site C *AND* Site B is the sum of costs on site links A-B *AND* A-C.
## For this reason:
- replication between Site B *AND* Site C is automatically routed through Site A to avoid the more expensive:
- transitive route.
## Connections are created between Site B *AND* Site C only if replication through Site A becomes impossible due to network *OR* bridgehead server conditions.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc755994(v=ws.10)

# Performance Limits for Replication Topology Generation

## Active Directory topology generation performance is limited primarily by the memory on the domain controller.
## KCC performance degrades at the physical memory limit.
## In most deployments:
- topology size will be limited by the amount of domain controller memory rather than CPU utilization required by the KCC.

## Scaling of sites *AND* domains is improved in Windows Server 2003 by improving the algorithm that the KCC uses to generate the intersite replication topology.
## Because all domain controllers must use the same algorithm to arrive at a consistent view of the replication topology:
- the improved algorithm has a forest functional level requirement of Windows Server 2003 *OR* Windows Server 2003 interim.

## KCC scalability was tested on domain controllers with 1.8 GHz processor speed:
- 512 megabytes (MB) RAM:
- *AND* small computer system interface (SCSI) disks.
## KCC performance results at forest functional levels that are at least Windows Server 2003 are described in the following table.
## The times shown are for the KCC to run where all new connections are needed (maximum) *AND* where no new connections are needed (minimum).
## Because most organizations add domain controllers in increments:
- the minimum generation times shown are closest to the actual runtimes that can be expected in deployments of comparable sizes.
## The CPU *AND* memory usage values for the Local Security Authority (LSA) process (Lsass.exe) indicate the more significant impact of memory versus percent of CPU usage when the KCC runs.

## Note

## Active Directory runs as part of the LSA:
- which manages authentication packages *AND* authenticates users *AND* services.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Goals of Replication Topology

## The KCC generates a replication topology that achieves the following goals:

## Connect every directory partition replica that must be replicated.

## Control replication latency *AND* cost.

## Route replication between sites.

## Effect client affinity.

## By default:
- the replication topology is managed automatically *AND* optimizes existing connections.
## However:
- manual connections created by an administrator are not modified *OR* optimized.

----------------------------------------------------

# Connect Directory Partition Replicas

## The total replication topology is actually composed of several underlying topologies:
- one for each directory partition.
## In the case of the schema *AND* configuration directory partitions:
- a single topology is created.
## The underlying topologies are merged to form the minimum number of connections that are required to replicate each directory partition between all domain controllers that store replicas.
## Where the connections for directory partitions are identical between domain controllers — for example:
- two domain controllers store the same domain directory partition — a single connection can be used for replication of updates to the domain:
- schema:
- *AND* configuration directory partitions.

## A separate replication topology is also created for application directory partitions.
## However:
- in the same manner as schema *AND* configuration directory partitions:
- application directory partitions can use the same topology as domain directory partitions.
## When application *AND* domain directory partitions are common to the source *AND* destination domain controllers:
- the KCC does not create a separate connection for the application directory partition.

## A separate topology is not created for the partial replicas that are stored on global catalog servers.
## The connections that are needed by a global catalog server to replicate each partial replica of a domain are part of the topology that is created for each domain.

## The routes for the following directory partitions *OR* combinations of directory partitions are aggregated to arrive at the overall topology:

## Configuration *AND* schema within a site.
## Each writable domain directory partition within a site.
## Each application directory partition within a site.
## Global catalog read-only:
- partial domain directory partitions within a site.

## Configuration *AND* schema between sites.
## Each writable domain directory partition between sites.
## Each application directory partition between sites.
## Global catalog read-only:
- partial domain directory partitions between sites.

## Replication transport protocols determine the manner in which replication data is transferred over the network media.
## Your network environment *AND* server configuration dictates the transports that you can use.
## For more information about transports:
- see “Replication Transports” later in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Control Replication Latency and Cost

## Replication latency is inherent in a multimaster directory service.
## A period of replication latency begins when a directory update occurs on an originating domain controller *AND* ends when replication of the change is received on the last domain controller in the forest that requires the change.
## Generally:
- the latency that is inherent in a WAN link is relative to a combination of the speed of the connection *AND* the available bandwidth.
## Replication cost is an administrative value that can be used to indicate the latency that is associated with different replication routes between sites.
## A lower-cost route is preferred by the ISTG when generating the replication topology.

## Site topology is the topology as represented by the physical network: the LANs *AND* WANs that connect domain controllers in a forest.
## The replication topology is built to use the site topology.
## The site topology is represented in Active Directory by site objects *AND* site link objects.
## These objects influence Active Directory replication to achieve the best balance between replication speed *AND* the cost of bandwidth utilization by distinguishing between replication that occurs within a site *AND* replication that must span sites.
## When the KCC creates replication connections between domain controllers to generate the replication topology:
- it creates more connections between domain controllers in the same site than between domain controllers in different sites.
## The results are lower replication latency within a site *AND* less replication bandwidth utilization between sites.

## Within sites:
- replication is optimized for speed as follows:
## Connections between domain controllers in the same site are always arranged in a ring:
- with possible additional connections to reduce latency.
## Replication within a site is triggered by a change notification mechanism when an update occurs:
- moderated by a short:
- configurable delay (because groups of updates frequently occur together).
## Data is sent uncompressed:
- *AND* thus without the processing overhead of data compression.

## Between sites:
- replication is optimized for minimal bandwidth usage (cost) as follows:
## Replication data is compressed to minimize bandwidth consumption over WAN links.
## Store-and-forward replication makes efficient use of WAN links — each update crosses an expensive link only once.
## Replication occurs at intervals that you can schedule so that use of expensive WAN links is managed.
## The intersite topology is a layering of spanning trees (one intersite connection between any two sites for each directory partition) *AND* generally does not contain redundant connections.

### what makes this important?
### what are your questions?
- what does the ISTG do again?
```
## The intersite topology generator is an Active Directory process that defines the replication between sites on a network.
## A single domain controller in each site is automatically designated to be the intersite topology generator.
## Because this action is performed by the intersite topology generator:
- you are not required to take any action to determine the replication topology *AND* bridgehead server roles.

## The domain controller that holds the intersite topology generator role performs two functions:

## It automatically selects one *OR* more domain controllers to become bridgehead servers.
## This way:
- if a bridgehead server becomes unavailable:
- it automatically selects another bridgehead server:
- if possible.

## It runs the KCC to determine the replication topology *AND* resultant connection objects that the bridgehead servers can use to communicate with bridgehead servers of other sites.
```
### what are the ideas?
### what are the terms and meanings?
- site topology
- ISTG intersite topology generator
- 
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?
- what made me like OOP?
- what made like development?
----------------------------------------------------

# Route Replication Between Sites

## The KCC uses the information in Active Directory to identify the least-cost routes for replication between sites.
## If a domain controller is unavailable at the time the replication topology is created:
- making replication through that site impossible:
- the next least-cost route is used.
## This rerouting is automatic when site links are bridged (transitive):
- which is the default setting.

## Replication is automatically routed around network failures *AND* offline domain controllers.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Effect Client Affinity

## Active Directory clients locate domain controllers according to their site affiliation.
## Domain controllers register SRV resource records in the DNS database that map the domain controller to a site.
## When a client requests a connection to a domain controller (for example:
- when logging on to a domain computer):
- the domain controller Locator uses the site SRV resource record to locate a domain controller with good connectivity whenever possible.
## In this way:
- a client locates a domain controller within the same site:
- thereby avoiding communications over WAN links.

## Sites can also be used by certain applications:
- such as DFS:
- to ensure that clients locate servers that are within the site or:
- if none is available:
- a server in the next closest site.
## If the ISTG is running Windows Server 2003 *OR* later server operating systems:
- you can specify an alternate site based on connection cost if no same-site servers are available.
## This DFS feature:
- called “site costing,” is new in Windows Server 2003.

## For more information about the domain controller Locator:
- see “DNS Support for Active Directory Technical Reference.” For more information about DFS site costing:
- see “DFS Technical Reference.”

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
Active Directory client
domain controller Locator
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Topology-Related Objects in Active Directory

## Active Directory stores replication topology information in the configuration directory partition.
## Several configuration objects define the components that are required by the KCC to establish *AND* implement the replication topology.

## Active Directory Sites *AND* Services is the Microsoft Management Console (MMC) snap-in that you can use to view *AND* manage the hierarchy of objects that are used by the KCC to construct the replication topology.
## The hierarchy is displayed as the contents of the Sites container:
- which is a child object of the Configuration container.
## The Configuration container is not identified in the Active Directory Sites *AND* Services UI.
## The Sites container contains an object for each site in the forest.
## In addition:
- Sites contains the Subnets container:
- which contains subnet definitions in the form of subnet objects.

## The following figure shows a sample hierarchy:
- including two sites: Default-First-Site-Name *AND* Site A.
## The selected NTDS Settings object of the server MHDC3 in the site Default-First-Site-Name displays the inbound connections from MHDC4 in the same site *AND* from A-DC-01 in Site A.
## In addition to showing that MHDC3 *AND* MHDC4 perform intrasite replication:
- this configuration indicates that MHDC3 *AND* A-DC-01 are bridgehead servers that are replicating the same domain between Site A *AND* Default-First-Site-Name.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Site and Subnet Objects

## Sites are effective because they map to specific ranges of subnet addresses:
- as identified in Active Directory by subnet objects.
## The relationship between sites *AND* subnets is integral to Active Directory replication.

----------------------------------------------------

## Site Objects
## A site object (class site) corresponds to a set of one *OR* more IP subnets that have LAN connectivity.
## Thus:
- by virtue of their subnet associations:
- domain controllers that are in the same site are well connected in terms of speed.
## Each site object has a child NTDS Site Settings object *AND* a Servers container.
## The distinguished name of the Sites container is CN=Sites,CN=Configuration,DC=ForestRootDomainName.
## The Configuration container is the topmost object in the configuration directory partition *AND* the Sites container is the topmost object in the hierarchy of objects that are used to manage *AND* implement Active Directory replication.

## When you install Active Directory on the first domain controller in the forest:
- a site object named Default-First-Site-Name is created in the Sites container in Active Directory.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Subnet Objects

## Subnet objects (class subnet) define network subnets in Active Directory.
## A network subnet is a segment of a TCP/IP network to which a set of logical IP addresses is assigned.
## Subnets group computers in a way that identifies their physical proximity on the network.
## Subnet objects in Active Directory are used to map computers to sites.
## Each subnet object has a siteObject attribute that links it to a site object.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Subnet-to-Site Mapping

## You associate a set of IP subnets with a site if they have high-bandwidth LAN connectivity:
- possibly involving hops through high-performance routers.

## Note

## LAN connectivity assumes high-speed:
- inexpensive bandwidth that allows similar *AND* reliable network performance:
- regardless of which two computers in the site are communicating.
## This quality of connectivity does not indicate that all servers in the site must be on the same network segment *OR* that hop counts between all servers must be identical.
## Rather:
- it is the measure by which you know that if a large amount of data needs to be copied from one server to another:
- it does not matter which servers are involved.
## If you find that you are concerned about such situations:
- consider creating another site.

## When you create subnet objects in Active Directory:
- you associate them with site objects so that IP addresses can be localized according to sites.
## During the process of domain controller location:
- subnet information is used to find a domain controller in the same site as:
- *OR* the site closest to:
- the client computer.

## The Net Logon service on a domain controller is able to identify the site of a client by mapping the client’s IP address to a subnet object in Active Directory.
## Likewise:
- when a domain controller is installed:
- its server object is created in the site that contains the subnet that maps to its IP address.

## You can use Active Directory Sites *AND* Services to define subnets:
- *AND* then create a site *AND* associate the subnets with the site.
## By default:
- only members of the Enterprise Admins group have the right to create new sites:
- although this right can be delegated.

## In a default Active Directory installation:
- there is no default subnet object:
- so potentially a computer can be in the forest *BUT* have an IP subnet that is not contained in any site.
## For private networks:
- you can specify the network addresses that are provided by the Internet Assigned Numbers Authority (IANA).
## By definition:
- that range covers all of the subnets for the organization.
## However:
- where several class B *OR* class C addresses are assigned:
- there would necessarily be multiple subnet objects that all mapped to the same default site.

## To accommodate this situation:
- use the following subnets:

## For class B addresses:
- subnet 128.0.0.0/2 covers all class B addresses.

## For class C addresses:
- subnet 192.0.0.0/3 covers all class C addresses.

## Note

## The Active Directory Sites *AND* Services MMC snap-in neither checks nor enforces IP address mapping when you move a server object to a different site.
## You must manually change the IP address on the domain controller to ensure proper mapping of the IP address to a subnet in the appropriate site.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Server Objects

## Server objects (class server) represent server computers:
- including domain controllers:
- in the configuration directory partition.
## When you install Active Directory:
- the installation process creates a server object in the Servers container within the site to which the IP address of the domain controller maps.
## There is one server object for each domain controller in the site.

## A server object is distinct from the computer object that represents the computer as a security principal.
## These objects are in separate directory partitions *AND* have separate globally unique identifiers (GUIDs).
## The computer object represents the domain controller in the domain directory partition --> the server object represents the domain controller in the configuration directory partition.
## The server object contains a reference to the associated computer object.

## The server object for the first domain controller in the forest is created in the Default-First-Site-Name site.
## When you install Active Directory on subsequent servers:
- if no other sites are defined:
- server objects are created in Default-First-Site-Name.
## If other sites have been defined *AND* subnet objects have been associated with these sites:
- server objects are created as follows:

## If additional sites have been defined in Active Directory *AND* the IP address of the installation computer matches an existing subnet in a defined site:
- the domain controller is added to that site.

## If additional sites have been defined in Active Directory *AND* the new domain controller's IP address does not match an existing subnet in one of the defined sites:
- the new domain controller's server object is created in the site of the source domain controller from which the new domain controller receives its initial replication.

## When Active Directory is removed from a server:
- its NTDS Settings object is deleted from Active Directory:
- *BUT* its server object remains because the server object might contain objects other than NTDS Settings.
## For example:
- when Microsoft Operations Manager *OR* Message Queuing is running on a domain controller:
- these applications create child objects beneath the server object.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# NTDS Settings Objects

## The NTDS Settings object (class nTDSDSA) represents an instantiation of Active Directory on that server *AND* distinguishes a domain controller from other types of servers in the site *OR* from decommissioned domain controllers.
## For a specific server object:
- the NTDS Settings object contains the individual connection objects that represent the inbound connections from other domain controllers in the forest that are currently available to send changes to this domain controller.

## Note

## The NTDS Settings object should not be manually deleted.
## The hasMasterNCs multivalued attribute (where “NC” stands for “naming context,” a synonym for “directory partition”) of an NTDS Settings object contains the distinguished names for the set of writable (non-global-catalog) directory partitions that are located on that domain controller:
- as follows:

## DC=Configuration,DC=ForestRootDomainName

## DC=Schema,DC=Configuration,DC=ForestRootDomainName

## DC=DomainName,DC=ForestRootDomainName

## The msDSHasMasterNCs attribute is new attribute introduced in Windows Server 2003:
- *AND* this attribute of the NTDS Settings object contains values for the above-named directory partitions as well as any application directory partitions that are stored by the domain controller.
## Therefore:
- on domain controllers that are DNS servers *AND* use Active Directory–integrated DNS zones:
- the following values appear in addition to the default directory partitions:

## DC=ForestDNSZones,DC=ForestRootDomainName (domain controllers in the forest root domain only)

## DC=DomainDNSZones,DC=DomainName,DC=ForestRootDomainName (all domain controllers)

## Applications that need to retrieve the list of all directory partitions that are hosted by a domain controller can be updated *OR* written to use the msDSHasMasterNCs attribute.
## Applications that need to retrieve only domain directory partitions can continue to use the hasMasterNCs attribute.

## For more information about these attributes:
- see Active Directory in the Microsoft Platform SDK on MSDN.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Connection Objects

## A connection object (class nTDSConnection) defines a one-way:
- inbound route from one domain controller (the source) to the domain controller that stores the connection object (the destination).
## The KCC uses information in cross-reference objects to create the appropriate connection objects:
- which enable domain controllers that store the same directory partitions to replicate with each other.
## The KCC creates connections for every server object in the Sites container that has an NTDS Settings object.

## The connection object is a child of the replication destination’s NTDS Settings object:
- *AND* the connection object references the replication source domain controller in the fromServer attribute on the connection object — that is:
- it represents the inbound half of a connection.
## The connection object contains a replication schedule *AND* specifies a replication transport.
## The connection object schedule is derived from the site link schedule for intersite connections.
## For more information about intersite connection schedules:
- see “Connection Object Schedule” later in this section.

## A connection is unidirectional --> a bidirectional replication connection is represented as two inbound connection objects.
## The KCC creates one connection object under the NTDS Settings object of each server that is used as an endpoint for the connection.

## Connection objects are created in two ways:

## Automatically by the KCC.

## Manually by a directory administrator by using Active Directory Sites *AND* Services:
- ADSI Edit:
- *OR* scripts.

## Intersite connection objects are created by the KCC that has the role of intersite topology generator (ISTG) in the site.
## One domain controller in each site has this role:
- *AND* the ISTG role owners in all sites use the same algorithm to collectively generate the intersite replication topology.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Ownership of Connection Objects

## Connections that are created automatically by the KCC are “owned” by the KCC.
## If you create a new connection manually,
- the connection is not owned by the KCC.
## If a connection object is not owned by the KCC,
- the KCC does not modify it *OR* delete it.

## Note

## One exception to this modification rule is that the KCC automatically changes the transport type of an administrator-owned connection if the transportType attribute is set incorrectly (see “Transport Type” later in this section).
## However,
- if you modify a connection object that is owned by the KCC (for example,
- you change the connection object schedule),
- the ownership of the connection depends on the application that you use to make the change:

## If you use an LDAP editor such as Ldp.exe *OR* Adsiedit.msc to change a connection object property,
- the KCC reverses the change the next time it runs.

## If you use Active Directory Sites *AND* Services to change a connection object property,
- the object is changed from automatic to manual *AND* the KCC no longer owns it.
## The UI indicates the ownership status of each connection object.

## In most Active Directory deployments,
- manual connection objects are not needed.

## If you create a connection object,
- it remains until you delete it,
- *BUT* the KCC will automatically delete duplicate KCC-owned objects if they exist *AND* will continue to create needed connections.
## Ownership of a connection object does not affect security access to the object --> it determines only whether the KCC can modify *OR* delete the object.

## Note

## If you create a new connection object that duplicates one that the KCC has already created,
- your duplicate object is created *AND* the KCC-created object is deleted by the KCC the next time it runs.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# ISTG and Modified Connections

## Because connection objects are stored in the configuration directory partition,
- it is possible for an intersite connection object to be modified by an administrator on one domain controller and,
- prior to replication of the initial change being received,
- to be modified by the KCC on another domain controller.
## Overwriting such a change can occur within the local site *OR* when a connection object changes in a remote site.

## By default,
- the KCC runs every 15 minutes.
## If the administrative connection object change is not received by the destination domain controller before the ISTG in the destination site runs,
- the ISTG in the destination site might modify the same connection object.
## In this case,
- ownership of the connection object belongs to the KCC because the latest write to the connection object is the write that is applied.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Manual Connection Objects

## The KCC is designed to produce a replication topology that provides low replication latency,
- that adapts to failures,
- *AND* that does not need modification.
## It is usually not necessary to create connection objects when the KCC is being used to generate automatic connections.
## The KCC automatically reconfigures connections as conditions change.
## Adding manual connections when the KCC is employed potentially increases replication traffic by adding redundant connections to the optimal set chosen by the KCC.
## When manually generated connections exist,
- the KCC uses them wherever possible.

## Adding extra connections does not necessarily reduce replication latency.
## Within a site,
- latency issues are usually related to factors other than the replication topology that is generated by the KCC.
## Factors that affect latency include the following:

## Interruption of the service of key domain controllers,
- such as the primary domain controller (PDC) emulator,
- global catalog servers,
- *OR* bridgehead servers.

## Domain controllers that are too busy to replicate in a timely manner (too few domain controllers).

## Network connectivity issues.

## DNS server problems.

## Inordinate amounts of directory updates.

## For problems such as these,
- creating a manual connection does not improve replication latency.
## Adjusting the scheduling *AND* costs that are assigned to the site link is the best way to influence intersite topology.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Site Link Objects

## For a connection object to be created on a destination domain controller in one site that specifies a source domain controller in another site,
- you must manually create a site link object (class siteLink) that connects the two sites.
## Site link objects identify the transport protocol *AND* scheduling required to replicate between two *OR* more sites.
## You can use Active Directory Sites *AND* Services to create the site links.
## The KCC uses the information stored in the properties of these site links to create the intersite topology connections.

## A site link is associated with a network transport by creating the site link object in the appropriate transport container (either IP *OR* SMTP).
## All intersite domain replication must use IP site links.
## The Simple Mail Transfer Protocol (SMTP) transport can be used for replication between sites that contain domain controllers that do not host any common domain directory partition replicas.

# Site Link Properties

## A site link specifies the following:

## Two *OR* more sites that are permitted to replicate with each other.

## An administrator-defined cost value associated with that replication path.
## The cost value controls the route that replication takes,
- *AND* thus the remote sites that are used as sources of replication information.

## A schedule during *WHICH* replication is permitted to occur.

## An interval that determines how frequently replication occurs over this site link during the times when the schedule allows replication.

## For more information about site link properties,
- see “Site Link Settings *AND* Their Effects on Intersite Replication” later in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Site Link Bridging

## By default,
- site links for the same IP transport that have sites in common are bridged,
- *WHICH* enables the KCC to treat the set of associated site links as a single route.
## If you categorically do not want the KCC to consider some routes,
- *OR* if your network is not fully routed,
- you can disable automatic bridging of all site links.
## When this bridging is disabled,
- you can create site link bridge objects *AND* manually add site links to a bridge.
## For more information about using site link bridges,
- see “Bridging Site Links Manually” later in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# NTDS Site Settings Object

## NTDS Site Settings objects (class nTDSSiteSettings) identify site-wide settings in Active Directory.
## There is one NTDS Site Settings object per site in the Sites container.
## NTDS Site Settings attributes control the following features *AND* conditions:

## The identity of the ISTG role owner for the site.
## The KCC on this domain controller is responsible for identifying bridgehead servers.
## For more information about this role,
- see “Automated Intersite Topology Generation” later in this section.

## Whether domain controllers in the site cache membership of universal groups *AND* the site in *WHICH* to find a global catalog server for creating the cache.

## The default schedule that applies to connection objects.
## For more information about this schedule,
- see “Connection Object Schedule” later in this section.

## Note

## To allow for the possibility of network failure,
- *WHICH* might cause one *OR* more notifications to be missed,
- a default schedule of once per hour is applied to replication within a site.
## You do not need to manage this schedule.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Cross-Reference Objects

## Cross-reference objects (class crossRef) store the location of directory partitions in the Partitions container (CN=Partitions,CN=Configuration,DC=ForestRootDomainName).
## The contents of the Partitions container are not visible by using Active Directory Sites *AND* Services,
- *BUT* can be viewed by using Adsiedit.msc to view the Configuration directory partition.

## Active Directory replication uses cross-reference objects to locate the domain controllers that store each directory partition.
## A cross-reference object is created during Active Directory installation to identify each new directory partition that is added to the forest.
## Cross-reference objects store the identity (nCName,
- the distinguished name of the directory partition where “NC” stands for “naming context,” a synonym for “directory partition”) *AND* location (dNSRoot,
- the DNS domain where servers that store the particular directory partition can be reached) of each directory partition.

## Note

## Starting in Windows Server 2003 Active Directory,
- a special attribute of the cross-reference object,
- msDS-NC-Replica-Locations,
- identifies application directory partitions to the replication system.
## For more information about how application directory partitions are replicated,
- see “Topology Generation Phases” later in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Replication Transports

## Replication transports provide the wire protocols that are required for data transfer.
## There are three levels of connectivity for replication of Active Directory information:

## Uniform high-speed,
- synchronous RPC over IP within a site.

## Point-to-point,
- synchronous,
- low-speed RPC over IP between sites.

## Low-speed,
- asynchronous SMTP between sites.

## The following rules apply to the replication transports:

## Replication within a site always uses RPC over IP.

## Replication between sites can use either RPC over IP *OR* SMTP over IP.

## Replication between sites over SMTP is supported for *ONLY* domain controllers of different domains.
## Domain controllers of the same domain must replicate by using the RPC over IP transport.
## Therefore,
- replication between sites over SMTP is supported for *ONLY* schema,
- configuration,
- *AND* global catalog replication,
- *WHICH* means that domains can span sites *ONLY* when point-to-point,
- synchronous RPC is available between sites.

## The Inter-Site Transports container provides the means for mapping site links to the transport that the link uses.
## When you create a site link object,
- you create it in either the IP container (which associates the site link with the RPC over IP transport) *OR* the SMTP container (which associates the site link with the SMTP transport).

## For the IP transport,
- a typical site link connects *ONLY* two sites *AND* corresponds to an actual WAN link.
## An IP site link connecting more than two sites might correspond to an asynchronous transfer mode (ATM) backbone that connects,
- for example,
- more than two clusters of buildings on a large campus *OR* connects several offices in a large metropolitan area that are connected by leased lines *AND* IP routers.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Synchronous and Asynchronous Communication

## The RPC intersite *AND* intrasite transport (RCP over IP within sites *AND* between sites) *AND* the SMTP intersite transport (SMTP over IP between sites only) correspond to synchronous *AND* asynchronous communication methods,
- respectively.
## Synchronous communication favors fast,
- available connections,
- while asynchronous communication is better suited for slow *OR* intermittent connections.

# Synchronous Replication Over IP

## The IP transport (RPC over IP) provides synchronous inbound replication.
## In the context of Active Directory replication,
- synchronous communication implies that after the destination domain controller sends the request for data,
- it waits for the source domain controller to receive the request,
- construct the reply,
- *AND* send the reply before it requests changes from any other domain controllers --> that is,
- inbound replication is sequential.
## Thus in synchronous transmission,
- the reply is received within a short time.
## The IP transport is appropriate for linking sites in fully routed networks.

# Asynchronous Replication Over SMTP

## The SMTP transport (SMTP over IP) provides asynchronous replication.
## In asynchronous replication,
- the destination domain controller does not wait for the reply *AND* it can have multiple asynchronous requests outstanding at any particular time.
## Thus in asynchronous transmission,
- the reply is not necessarily received within a short time.
## Asynchronous transport is appropriate for linking sites in networks that are not fully routed *AND* have particularly slow WAN links.

## Note

## Although asynchronous replication can send multiple replication requests in parallel,
- the received replication packets are queued on the destination domain controller *AND* the changes applied for *ONLY* one partner *AND* directory partition at a time.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Replication Queue

## Suppose a domain controller has five inbound replication connections.
## As the domain controller formulates change requests,
- *EITHER* by a schedule being reached *OR* from a notification,
- it adds a work item for each request to the end of the queue of pending synchronization requests.
## Each pending synchronization request represents one <source domain controller,
- directory partition> pair,
- such as “synchronize the schema directory partition from DC1,” *OR* “delete the ApplicationX directory partition.”

## When a work item has been received into the queue,
- notification *AND* polling intervals do not apply — the domain controller processes the item (begins synchronizing from that source) as soon as the item reaches the front of the queue,
- *AND* continues until *EITHER* the destination is fully synchronized with the source domain controller,
- an error occurs,
- *OR* the synchronization is pre-empted by a higher-priority operation.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# SMTP Intersite Replication

## When sites are on opposite ends of a WAN link (or the Internet),
- it is not always desirable — *OR* even possible — to perform synchronous,
- RPC-based directory replication.
## In some cases,
- the *ONLY* method of communication between two sites is e-mail.
## When connectivity is intermittent *OR* when end-to-end IP connectivity is not available (an intermediate site does not support RPC/IP replication),
- replication must be possible across asynchronous,
- store-and-forward transports such as SMTP.

## In addition,
- where bandwidth is limited,
- it can be disadvantageous to force an entire replication cycle of request for changes *AND* transfer of changes between two domain controllers to complete before another can begin (that is,
- to use synchronous replication).
## With SMTP,
- several cycles can be processing simultaneously so that each cycle is being processed to some degree most of the time,
- as opposed to receiving no attention for prolonged periods,
- *WHICH* can result in RPC time-outs.

## For intersite replication,
- SMTP replication substitutes mail messaging for the RPC transport.
## The message syntax is the same as for RPC-based replication.
## There is no change notification for SMTP–based replication,
- *AND* scheduling information for the site link object is used as follows:

## By default,
- SMTP replication ignores the Replication Available *AND* Replication Not Available settings on the site link schedule in Active Directory Sites *AND* Services (the information that indicates when these sites are connected).
## Replication occurs according to the messaging system schedule.

## Within the scope of the messaging system schedule,
- SMTP replication uses the replication interval that is set on the SMTP site link to indicate how often the server requests changes.
## The interval (Replicate every ____ minutes) is set in 15-minute increments on the General tab in site link Properties in Active Directory Sites *AND* Services.

## The underlying SMTP messaging system is responsible for message routing between SMTP servers.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# SMTP Replication and Intersite Messaging

## Intersite Messaging is a component that is enabled when Active Directory is installed.
## Intersite Messaging allows for multiple transports to be used as add-ins to the Intersite Messaging architecture.
## Intersite Messaging enables messaging communication that can use SMTP servers other than those that are dedicated to processing e-mail applications.

## When the forest has a functional level of at least Windows 2000,
- Intersite Messaging also provides services to the KCC in the form of querying the available replication paths.
## In addition,
- Net Logon queries the connectivity data in Intersite Messaging when calculating site coverage.
## By default,
- Intersite Messaging rebuilds its database once a day,
- *OR* when required by a site link change.

## When the forest has a functional level of at least Windows Server 2003,
- the KCC does *NOT* use Intersite Messaging for calculating the topology.
## However,
- regardless of forest functional level,
- Intersite Messaging is still required for SMTP replication,
- DFS,
- universal group membership caching,
- *AND* Net Logon automatic site coverage calculations.
## Therefore,
- if any of these features are in use,
- do *NOT* stop Intersite Messaging.

## For more information about site coverage *AND* how automatic site coverage is calculated,
- see “How DNS Support for Active Directory Works.” For more information about DFS,
- see “DFS Technical Reference.”

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Requirements for SMTP Replication

## The KCC does *NOT* create connections that use SMTP until the following requirements are met:

## Internet Information Services (IIS) is installed on both bridgehead servers.

## An enterprise certification authority (CA) is installed *AND* configured on your network.
## The CA signs *AND* encrypts SMTP messages that are exchanged between domain controllers,
- ensuring the authenticity of directory updates.
## *Specifically*,
- a domain controller certificate must be present on the replicating domain controllers.
## The replication request message,
- *WHICH* contains no directory data,
- is *NOT* encrypted.
## The replication reply message,
- *WHICH* does contain directory data,
- is encrypted using a key length of 128 bits.

## The sites are connected by SMTP site links.

## The site link path between the sites has a lower cost than any IP/RPC site link that can reach the SMTP site.

## You are *NOT* attempting to replicate writable replicas of the same domain (although replication of global catalog partial replicas is supported).

## Each domain controller is configured to receive mail.

## You must also determine if mail routing is necessary.
## If the two replicating domain controllers have direct IP connectivity *AND* can send mail to each other,
- no further configuration is required.
## However,
- if the two domain controllers must go through mail gateways to deliver mail to each other,
- you must configure the domain controller to use the mail gateway.

## Note

## RPC is required for replicating the domain to a new domain controller *AND* for installing certificates.
## If RPC is *NOT* available to the remote site,
- the domain must be replicated *AND* certificates must be installed over RPC in a hub site *AND* the domain controller then shipped to the remote site.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Comparison of SMTP and RPC Replication

## The following characteristics apply to both SMTP *AND* RPC with respect to Active Directory replication:

## For replication <-- *BETWEEN* --> sites,
- data that is replicated through *EITHER* transport is compressed.

## Active Directory can respond with *ONLY* a fixed (maximum) number of changes per change request,
- based on the size of the replication packet.
## The size of the replication packet is configurable.
## For information about configuring the replication packet size,
- see “Replication Packet Size” later in this section.

## Active Directory can apply a single set of changes at a time for a specific directory partition *AND* replication partner.

## The response data (changes) are transported in one *OR* many frames,
- based on the total number of changed *OR* new values.

## TCP transports the data portion *BY* using the same algorithm for both SMTP *AND* RPC.

## If transmission of the data portion fails,
- complete retransmission is necessary.

## Point-to-point synchronous RPC replication is available <-- *BETWEEN* --> sites to allow the flexibility of having domains that span multiple sites.
## RPC is best used <-- *BETWEEN* --> sites that are connected *BY* WAN links because it involves lower latency.
## SMTP is best used <-- *BETWEEN* --> sites where RPC over IP is *NOT* possible.
## For example,
- SMTP can be used *BY* companies that have a network backbone that is *NOT* based on TCP/IP,
- such as companies that use an X.400 backbone.

## Active Directory replication uses both transports to implement a request-response mechanism.
## Active Directory issues requests for changes *AND* replies to requests for changes.
## RPC maps these requests into RPC requests *AND* RPC replies.
## SMTP,
- on the other hand,
- actually uses long-lived TCP connections (or X.400-based message transfer agents in non-TCP/IP networks) to deliver streams of mail in each direction.
## Thus,
- RPC transport expects a response to any request immediately *AND* can have a maximum of one active inbound RPC connection to a directory partition replica at a time.
## The SMTP transport expects much longer delays <-- *BETWEEN* --> a request *AND* a response.
## As a result,
- multiple inbound SMTP connections to a directory partition replica can be active at the same time,
- provided the requests are all for a different source domain controller or,
- for the same source domain controller,
- a different directory partition.
## For more information,
- see “Synchronous *AND* Asynchronous Communication” earlier in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Replication Packet Size

## Replication packet sizes are computed on the basis of memory size *UNLESS* you have more than 1 gigabyte (GB).
## By default,
- the system limits the packet size as follows:

## The packet size in bytes is 1/100th the size of RAM,
- with a minimum of 1 MB *AND* a maximum of 10 MB.

## The packet size in objects is 1/1,000,000th the size of RAM,
- with a minimum of 100 objects *AND* a maximum of 1,000 objects.
## For general estimates when this entry is *NOT* set,
- assume an approximate packet size of 100 objects.

## There is one exception: the value of the Replicator async inter site packet size (bytes) registry entry is always 1 MB if it is *NOT* set (that is,
- when the default value is in effect).
## Many mail systems limit the amount of data that can be sent in a mail message (2 MB to 4 MB is common),
- *ALTHOUGH* most Windows-based mail systems can handle large 10-MB mail messages.

## Overriding these memory-based values might be beneficial in advanced bandwidth management scenarios.
## You can edit the registry to set the maximum packet size.

## Note

## If you must edit the registry,
- use extreme caution.
## Registry information is provided here as a reference for use *BY* *ONLY* highly skilled directory service administrators.
## It is recommended that you do *NOT* directly edit the registry unless,
- as in this case,
- there is no Group Policy *OR* other Windows tools to accomplish the task.
## Modifications to the registry are *NOT* validated *BY* the registry editor *OR* *BY* Windows before they are applied,
- *AND* as a result,
- incorrect values can be stored.
## Storage of incorrect values can result in unrecoverable errors in the system.
## Setting the maximum packet size requires adding *OR* modifying entries in the following registry path with the REG_DWORD data type: HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\NTDS\Parameters.
## These entries can be used to determine the maximum number of objects per packet *AND* maximum size of the packets.
## The minimum values are indicated as the lowest value in the range.

## For RPC replication within a site:

## Replicator intra site packet size (objects)

## Range: >=2

## Replicator intra site packet size (bytes)

## Range: >=10 KB

## For RPC replication <-- *BETWEEN* --> sites:

## Replicator inter site packet size (objects)

## Range: >=2

## Replicator inter site packet size (bytes)

## Range: >=10 KB

## For SMTP replication <-- *BETWEEN* --> sites:

## Replicator async inter site packet size (objects)

## Range: >=2

## Replicator async inter site packet size (bytes)

## Range: >=10 KB

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Transport Type

## The transportType attribute of a connection object specifies *WHICH* network transport is used when the connection is used for replication.
## The transport type receives its value from the distinguished name of the container in the configuration directory partition that contains the site link over *WHICH* the connection occurs,
- as follows:

## Connection objects that use TCP/IP have the transportType value of CN=IP,CN=Inter-Site Transports,CN=IP,DC=Configuration,DC=ForestRootDomainName.

## Connection objects that use SMTP/IP have the transportType value of CN=SMTP,CN=Inter-Site Transports,CN=IP,DC=Configuration,DC=ForestRootDomainName.

## For intrasite connections,
- transportType has no value --> Active Directory Sites *AND* Services shows the transport of “RPC” for connections that are from servers in the same site.

## If you move a domain controller to a different site,
- the connection objects from servers in the site from *WHICH* it was moved remain,
- *BUT* the transport type is blank because it was an intrasite connection.
## Because the connection has an endpoint outside of the site,
- the local KCC in the server’s new site does *NOT* manage the connection.
## When the ISTG runs,
- if a blank transport type is found for a connection that is from a server in a different site,
- the transportType value is automatically changed to IP.
## The ISTG in the site determines whether to delete the connection object *OR* to retain it,
- in *WHICH* case the server becomes a bridgehead server in its new site.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Replication Between Sites

## Replication <-- *BETWEEN* --> sites transfers domain updates when domain controllers for a domain are located in more than one site.
## Intersite replication of configuration *AND* schema changes is *ALWAYS* required when more than one site is configured in a forest.
## Replication <-- *BETWEEN* --> sites is accomplished *BY* bridgehead servers,
- *WHICH* replicate changes according to site link settings.

# Bridgehead Servers

## *WHEN* domain controllers for the same domain are located in different sites,
- at least one bridgehead server per directory partition *AND* per transport (IP *OR* SMTP) replicates changes from one site to a bridgehead server in another site.
## A single bridgehead server *CAN* serve multiple partitions per transport *AND* multiple transports.
## Replication within the site allows updates to flow <-- *BETWEEN* --> the bridgehead servers *AND* the other domain controllers in the site.
## Bridgehead servers help to ensure that the data replicated across WAN links is *NOT* stale *OR* redundant.

## Any server that has a connection object with a “from” server in another site is acting as a destination bridgehead.
## Any server that is acting as a source for a connection to another site acts as a source bridgehead.

## Note

## You *CAN* identify a KCC-selected bridgehead server in Active Directory Sites *AND* Services *BY* viewing connection objects for the server (select the NTDS Settings object below the server object) --> *IF* there are connections from servers in a different site *OR* sites,
- the server represented *BY* the selected NTDS Settings object is a bridgehead server.
 *IF* you have Windows Support Tools installed,
- you *CAN* see all bridgehead servers *BY* using the command repadmin /bridgeheads.
## KCC selection of bridgehead servers guarantees bridgehead servers that are capable of replicating all directory partitions that are needed in the site,
- including partial global catalog partitions.
## By default,
- bridgehead servers are selected automatically *BY* the KCC on the domain controller that holds the ISTG role in each site.
 *IF* you want to identify the domain controllers that *CAN* act as bridgehead servers,
- you *CAN* designate preferred bridgehead servers,
- from *WHICH* the ISTG selects all bridgehead servers.
## Alternatively,
- *IF* the ISTG is *NOT* used to generate the intersite topology,
- you *CAN* create manual intersite connection objects on domain controllers to designate bridgehead servers.

## In sites that have at least one domain controller that is running Windows Server 2003,
- the ISTG *CAN* select bridgehead servers from all eligible domain controllers for each directory partition that is represented in the site.
## For example,
- *IF* three domain controllers in a site store replicas of the same domain *AND* domain controllers for this domain are also located in three *OR* more other sites,
- the ISTG *CAN* spread the inbound connection objects from those sites among all three domain controllers,
- including those that are running Windows 2000 Server.

## In Windows 2000 forests,
- a single bridgehead server per directory partition *AND* per transport is designated as the bridgehead server that is responsible for intersite replication of that directory partition.
## *THEREFORE*,
- for the preceding example,
- *ONLY* one of the three domain controllers would be designated *BY* the ISTG as a bridgehead server for the domain,
- *AND* all four connection objects from the four other sites would be created on the single bridgehead server.
## In large hub sites,
- a single domain controller might *NOT* be able to adequately respond to the volume of replication requests from perhaps thousands of branch sites.

## For more information about how the KCC selects bridgehead servers,
- see “Bridgehead Server Selection” later in this section.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Compression of Replication Data

## Intersite replication is compressed *BY* default.
## Compressing replication data allows the data to be transferred over WAN links more quickly,
- thereby conserving network bandwidth.
## The cost of this benefit is an increase in CPU utilization on bridgehead servers.

## By default,
- replication data is compressed under the following conditions:

## Replication of updates <-- *BETWEEN* --> domain controllers in different sites.

## Replication of Active Directory to a newly created domain controller.

## A new compression algorithm is employed *BY* bridgehead servers that are running at least Windows Server 2003.
## The new algorithm improves replication speed *BY* operating <-- *BETWEEN* --> two *AND* ten times faster than the Windows 2000 Server algorithm.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Windows 2000 Server Compression

## The compression algorithm that is used *BY* domain controllers that are running Windows 2000 Server achieves a compression ratio of approximately 75% to 85%.
## The cost of this compression in terms of CPU utilization *CAN* be as high as 50% for intersite Active Directory replication.
## In some cases,
- the CPUs on bridgehead servers that are running Windows 2000 Server *CAN* become overwhelmed with compression requests,
- compounded *BY* the need to service outbound replication partners.
## In a worst case scenario,
- the bridgehead server becomes so overloaded that it cannot keep up with outbound replication.
## This scenario is usually coupled with a replication topology issue where a domain controller has more outbound partners than necessary *OR* the replication schedule was overly aggressive for the number of direct replication partners.

## Note

## *IF* a bridgehead server has too many replication partners,
- the KCC logs event ID 1870 in the Directory Service log,
- indicating the current number of partners *AND* the recommended number of partners for the domain controller.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Windows Server 2003 Compression

## On domain controllers that are running Windows Server 2003,
- compression quality is comparable to Windows 2000 *BUT* the processing burden is greatly decreased.
## The Windows Server 2003 algorithm produces a compression ratio of approximately 60%,
- *WHICH* is slightly less compression than is achieved *BY* the Windows 2000 Server ratio,
- *BUT* *WHICH* significantly reduces the processing load on bridgehead servers.
## The new compression algorithm provides a good compromise *BY* significantly reducing the CPU load on bridgehead servers,
- while *ONLY* slightly increasing the WAN traffic.
## The new algorithm reduces the time taken *BY* compression from approximately 60% of replication time to 20%.

## The Windows Server 2003 compression algorithm is used *ONLY* *WHEN* both bridgehead servers are running Windows Server 2003.
## *IF* a bridgehead server that is running Windows Server 2003 replicates with a bridgehead server that is running Windows 2000 Server,
- then the Windows 2000 compression algorithm is used.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Reverting to Windows 2000 Compression

## For slow WAN links (for example,
- 64 KB *OR* less),
- *IF* more compression is preferable to a decrease in computation time,
- you *CAN* change the compression algorithm to the Windows 2000 algorithm.
## The compression algorithm is controlled *BY* the REG_DWORD registry entry HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NTDS\Parameters\Replicator compression algorithm.
## By editing this registry entry,
- you *CAN* change the algorithm that is used for compression to the Windows 2000 algorithm.

## Note

## *IF* you must edit the registry,
- use extreme caution.
## Registry information is provided here as a reference for use *BY* *ONLY* highly skilled directory service administrators.
## It is recommended that you do *NOT* directly edit the registry *UNLESS*,
- as in this case,
- there is no Group Policy *OR* other Windows tools to accomplish the task.
## Modifications to the registry are *NOT* validated *BY* the registry editor *OR* *BY* Windows before they are applied,
- *AND* as a result,
- incorrect values *CAN* be stored.
## Storage of incorrect values *CAN* result in unrecoverable errors in the system.
## The default value is 3,
- *WHICH* indicates that the Windows Server 2003 algorithm is in effect.
## By changing the value to 2,
- the Windows 2000 algorithm is used for compression.
## However,
- switching to the Windows 2000 algorithm is *NOT* recommended *UNLESS* both bridgehead domain controllers serve relatively few branches *AND* have ample CPU (for example,
- > dual processor 850 megahertz [MHz]).

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Site Link Settings and Their Effects on Intersite Replication

## In Active Directory Sites *AND* Services,
- the General tab of the site link Properties contains the following options for configuring site links to control the replication topology:

## A list of two *OR* more sites to be connected.

## A single numeric cost that is associated with communication over the link.
## The default cost is 100,
- *BUT* you *CAN* assign higher cost values to represent more expensive transmission.
## For example,
- sites that are connected *BY* low-speed *OR* dial-up connections would have high-cost site links <-- *BETWEEN* --> them.
## Sites that are well connected through backbone lines would have low-cost site links.
## Where multiple routes *OR* transports exist <-- *BETWEEN* --> two sites,
- the least expensive route *AND* transport combination is used.

## A schedule that determines days *AND* hours during *WHICH* replication *CAN* occur over the link (the link is available).
## For example,
- you might use the default (100 percent available) schedule on most links,
- *BUT* block replication traffic during peak business hours on links to certain branches.
## By blocking replication,
- you give priority to other traffic,
- *BUT* you also increase replication latency.

## Note

## Scheduling information is ignored *BY* site links that use SMTP transports --> the mail is stockpiled *AND* then exchanged at the times that are configured for your mail infrastructure.
## An interval in minutes that determines how often replication *CAN* occur (default is every 180 minutes,
- *OR* 3 hours).
## The minimum interval is 15 minutes.
## *IF* the interval exceeds the time allowed *BY* the schedule,
- replication occurs once at the scheduled time.

## A site *CAN* be connected to other sites *BY* any number of site links.
## For example,
- a hub site has site links to each of its branch sites.
## Each site that contains a domain controller in a multisite directory must be connected to at least one other site *BY* at least one site link --> otherwise,
- it cannot replicate with domain controllers in any other site.

## The following diagram shows two sites that are connected *BY* a site link.
## Domain controllers DC1 *AND* DC2 belong to the same domain *AND* are acting as partner bridgehead servers.
## *WHEN* topology generation occurs,
- the ISTG in each site creates an inbound connection object on the bridgehead server in its site from the bridgehead server in the opposite site.
## With these objects in place,
- replication *CAN* occur according to the settings on the SB site link.

## Connections <-- *BETWEEN* --> Domain Controllers in Two Sites that Are Connected *BY* a Site Link

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Site Link Cost

## The ISTG uses the cost settings on site links to determine the route of replication <-- *BETWEEN* --> three *OR* more sites that replicate the same directory partition.
## The default cost value on a site link object is 100.
## You *CAN* assign lower *OR* higher cost values to site links to favor inexpensive connections over expensive connections,
- respectively.
## Certain applications *AND* services,
- such as domain controller Locator *AND* DFS,
- also use site link cost information to locate nearest resources.
## For example,
- site link cost *CAN* be used to determine *WHICH* domain controller is contacted *BY* clients located in a site that does *NOT* include a domain controller for the specified domain.
## The client contacts the domain controller in a different site according to the site link that has the lowest cost assigned to it.

## Cost is usually assigned *NOT* *ONLY* on the basis of the total bandwidth of the link,
- *BUT* also on the availability,
- latency,
- *AND* monetary cost of the link.
## For example,
- a 128-kilobits per second (Kbps) permanent link might be assigned a lower cost than a dial-up 128-Kbps dual ISDN link because the dial-up ISDN link has replication latency-producing delay that occurs as the links are being established *OR* removed.
## Furthermore,
- in this example,
- the permanent link might have a fixed monthly cost,
- whereas the ISDN line is charged according to actual usage.
## Because the company is paying up-front for the permanent link,
- the administrator might assign a lower cost to the permanent link to avoid the extra monetary cost of the ISDN connections.

## The method used *BY* the ISTG to determine the least-cost path from each site to every other site for each directory partition is more efficient *WHEN* the forest has a functional level of *AT LEAST* Windows Server 2003 than it is at other levels.
## For more information about how the KCC computes replication routes,
- see “Automated Intersite Topology Generation” later in this section.
## For more information about domain controller location,
- see “How DNS Support for Active Directory Works.”

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Transitivity and Automatic Site Link Bridging

## By default,
- site links are transitive,
- *OR* bridged.
## *IF* site A has a common site link with site B,
- site B also has a common site link with Site C,
- *AND* the two site links are bridged,
- domain controllers in site A *CAN* replicate directly with domain controllers in site C under certain conditions,
- even though there is no site link <-- *BETWEEN* --> site A *AND* site C.
## In other words,
- the effect of bridged site links is that replication <-- *BETWEEN* --> sites in the bridge is transitive.

## The setting that implements automatic site link bridges is Bridge all site links,
- *WHICH* is found in Active Directory Sites *AND* Services in the properties of the IP *OR* SMTP intersite transport containers.
## The default bridging of site links occurs automatically *AND* no directory object represents the default bridge.
## *THEREFORE*,
- in the common case of a fully routed IP network,
- you do *NOT* need to create any site link bridge objects.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Transitivity and Rerouting

## For a set of bridged site links,
- where replication schedules in the respective site links overlap (replication is available on the site links during the same time period),
- connection objects *CAN* be automatically created,
- *IF* needed,
- <-- *BETWEEN* --> sites that do *NOT* have site links that connect them directly.
## All site links for a specific transport implicitly belong to a single site link bridge for that transport.

## Site link transitivity enables the KCC to re-route replication *WHEN* necessary.
## In the next diagram,
- a domain controller that *CAN* replicate the domain is *NOT* available in Seattle.
## In this case,
- because the site links are transitive (bridged) *AND* the schedules on the two site links allow replication *AT THE SAME TIME*,
- the KCC *CAN* re-route replication *BY* creating connections <-- *BETWEEN* --> DC3 in Portland *AND* DC2 in Boston.
## Connections <-- *BETWEEN* --> domain controllers in Portland *AND* Boston might also be created *WHEN* a domain controller in Portland is a global catalog server,
- *BUT* no global catalog server exists in the Seattle site *AND* the Boston site hosts a domain that is *NOT* present in the Seattle site.
## In this case,
- connections *CAN* be created <-- *BETWEEN* --> Portland *AND* Boston to replicate the global catalog partial,
- read- *ONLY* replica.

## Note

## Overlapping schedules are required for site link transitivity,
- even *WHEN* Bridge all site links is enabled.
## In the example,
- *IF* the site link schedules for SB *AND* PS do *NOT* overlap,
- no connections are possible <-- *BETWEEN* --> Boston *AND* Portland.

## In the preceding diagram,
- creating a third site link to connect the Boston *AND* Portland sites is unnecessary *AND* counterproductive because of the way that the KCC uses cost to route replication.
## In the configuration that is shown,
- the KCC uses cost to choose *EITHER* the route <-- *BETWEEN* --> Portland *AND* Seattle *OR* the route <-- *BETWEEN* --> Portland *AND* Boston.
## *IF* you wanted the KCC to use the route <-- *BETWEEN* --> Portland *AND* Boston,
- you would create a site link <-- *BETWEEN* --> Portland *AND* Boston instead of the site link <-- *BETWEEN* --> Portland *AND* Seattle.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Aggregated Site Link Cost and Routing

## *WHEN* site links are bridged,
- the cost of replication from a domain controller at one end of the bridge to a domain controller at the other end is the sum of the costs on each of the intervening site links.
## For this reason,
- *IF* a domain controller in an interim site stores the directory partition that is being replicated,
- the KCC will route replication to the domain controller in the interim site rather than to the more distant site.
## The domain controller in the more distant site in turn receives replication from the interim site (store-and-forward replication).
## *IF* the schedules of the two site links overlap,
- this replication occurs in the same period of replication latency.

## The following diagram illustrates an example where two site links connecting three sites that host the same domain are bridged automatically (Bridge all site links is enabled).
## The aggregated cost of directly replicating <-- *BETWEEN* --> Portland *AND* Boston illustrates why the KCC routes replication from Portland to Seattle *AND* from Seattle to Boston in a store-and-forward manner.
## Given the choice <-- *BETWEEN* --> replicating at a cost of 4 from Seattle *OR* a cost of 7 from Boston,
- the ISTG in Portland chooses the lower cost *AND* creates the connection object on DC3 from DC1 in Seattle.

## In the preceding diagram,
- *IF* DC3 in Portland needs to replicate a directory partition that is hosted on DC2 in Boston *BUT* *NOT* *BY* any domain controller in Seattle,
- *OR* *IF* the directory partition is hosted in Seattle *BUT* the Seattle site cannot be reached,
- the ISTG creates the connection object from DC2 to DC3.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Significance of Overlapping Schedules

## In the preceding diagram,
- to replicate the same domain that is hosted in all three sites,
- the Portland site replicates directly with Seattle *AND* Seattle replicates directly with Boston,
- transferring Portland’s changes to Boston,
- *AND* vice versa,
- through store-and-forward replication.
## Whether the schedules overlap has the following effects:

## PS *AND* SB site link schedules have replication available during *AT LEAST* one common hour of the schedule:

## Replication <-- *BETWEEN* --> these two sites occurs in the same period of replication latency,
- being routed through Seattle.

## *IF* Seattle is unavailable,
- connections *CAN* be created <-- *BETWEEN* --> Portland *AND* Boston.

## PS *AND* SB site link schedules have no common time:

## Replication of changes <-- *BETWEEN* --> Portland *AND* Boston reach their destination in the next period of replication latency after reaching Seattle.

## *IF* Seattle is unavailable,
- no connections are possible <-- *BETWEEN* --> Portland *AND* Boston.

## Note

## *IF* Bridge all site links is disabled,
- a connection is never created <-- *BETWEEN* --> Boston *AND* Portland,
- *REGARDLESS* of schedule overlap,
- *UNLESS* you manually create a site link bridge.

### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Site Link Changes and Replication Path

