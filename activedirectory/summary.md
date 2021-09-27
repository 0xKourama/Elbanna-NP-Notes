# AD replication requires:
1. a routable IP infrastructure
2. DNS
3. RPC
4. Kerberos V5
5. LDAP
6. NETLOGON
7. intersite message for (SMTP)
# to avoid contacting domain controllers over costly WAN links *AND* to use domain controllers in the same site:
- the *domain controller locator* uses the SRV records which map a domain controller to a site
# the DC with the connection object linking with another site indicates that they are both the bridgeheads for intersite replication
# Site -> LAN
# GCs store domain data for all objects in AD to save computers in the forest from querying exact domain controllers for domain data. it hosts full writable replicas for schema, configuration and the domain partition for the domain it's in. it also hold a read-only partial set of attributes of all other domains in the forest.
# with universal group caching enabled, there isn't a need for a GC to be hosted in every site. This also reduces the logon time because the DCs doing the authentication don't need to access a GC for universal group membership data.
# intrasite replication --> priority is speed
# intersite replication --> priority is bandwidth utilization
# A network subnet is a segment of a TCP/IP network to which a set of logical IP addresses is assigned.
# Subnet objects in Active Directory are used to map computers to sites.
# map a subnet to site only if you're sure of high-speed low-cost connectivity --> mapping a subnet to the wrong site can cause problems
# The Net Logon service on a domain controller identifies the client' site by looking at it's subnet.
# if you move a DC to another site, you have to manually change the IP so that the DC belongs in the correct subnet and thus correct site
# if a DC is added in a subnet that doesn't exist, it is added to the site of the DC that gave it it's first replication (the DC that gave him his first replication should be the closest)
# Each DC has a NTDS settings object
# NTDS settings object is part of every domain controller and contains the inbound replication connections
# NTDS settings object has hasMasterNCs which tells which NCs that the server holds (excluding application partitions. a.k.a schema, config, domain)
# NTDS settings object has msDSHasMasterNCs which tells which NCs that the server holds (including application partitions)
# Domain controllers that store the same directory partitions to replicate with each other.
# the KCC only deals with connection objects it created (it's the owner)
# Factors that affect latency include the following:
1. interruptin of key DCs like: PDC or GC or Bridgehead
2. DNS problems
3. overloaded domain controllers
4. too many updates
5. networking connetivity problems
6. security problems
# global catalog servers have universal group memberships
# NTDS site settings tell which server is the ISTG and has the option of switching on Universal Group Membership Caching and choosing which GC to obtain the information from
# cross reference objects store the location of each directory partition
# intra-site replication must happen using synchronous high-speed RPC over IP
# inter-site Replication over asynchronous low-speed SMTP is supported for *ONLY* domain controllers of different domains. This means that *ONLY* schema, configuration and global gatalog can be replicated inter-site using SMTP transport.
# DCs of the same domain must replicate using RPC over IP. this means, that domains can span sites *ONLY* when RPC over IP is available.
# synchronous connections are for fast & available connections while asynchronous connections are for slow intermittent connections.
# the replication queue is formed of sync requests which are [partition to be synced + source DC]. each request is processed until complete, gets an error or pre-empted by a higher priority operation.
# the KCC doesn't create SMTP transports unless,
1. IIS is installed on both bridgeheads
2. there's a CA that encrypts the replication reply message; the replication request doesn't contain domain data so it doesn't need to be encrypted.
# if a DC was moved to a site, and the connection object remains, it gets changed to blank transport and the KCC doesn't work on it. The ISTG works on it by changing it to IP transport and determines whether to keep the connection or delete it and makes that server the bridgehead.
# inter-site replication transfers domain updates when the domain is split accross multiple sites.
# inter-site replication is required for schema, config and GC either way.
# bridghead servers are the ones responsible for inter-site replication.
# the KCC on the DC that holds the ISTG role is the one that selects the bridgehead server(s) for a site.
# two replication types are compressed:
1. inter-site replication
2. replication to a newly created domain controller
*bridgehead server of version 2003 and above use a new compression algorithm that's 2-10 times faster than server 2000 and uses less CPU but the compression rate isn't as good as 2000*
*naturally, using the 2003 algorith requires both bridgeheads to be 2003. reverting to 2000 can be done if we want to minimize bandwidth*
# if a bridgehead has too many replication partners. it logs and event with current and recommended number of partners.
# [me] using high processing power for bridgeheads is the way to go to prevent failure
# site link are transitive:
1. if site A linked to site B
2. site B linked to site C
3. site A can replicate with with site C without a link
# connections can be created transitively when there's no global catalog/same domain in the nearby site. a connection gets created to replicate the partial attribute set.
# site link schedules must overlap before transitive replication can be done.
# "Bridge all site links" connects two or more site links. Using this option requires that all sites are fully routable.
# inter-site replication topology is calculated when the KCC on every site's ISTG runs and does replication path calculations according to cost
# intra-site replication starts 15 seconds after a change has been made
# SMTP transport doesn't support file replication (SYSVOL). Logon scripts and group policies won't be replicated