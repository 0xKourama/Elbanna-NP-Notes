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


# Global catalog
# The global catalog is a feature of Active Directory (“AD”) domain controllers that allows for a domain controller to provide information on any object in the forest:
- regardless of whether the object is a member of the domain controller’s domain.

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