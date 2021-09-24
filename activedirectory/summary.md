# to avoid contacting domain controllers over costly WAN links *AND* to use domain controllers in the same site:
- the *domain controller locator* uses the SRV records which map a domain controller to a site
# the DC with the connection object linking with another site indicates that they are both the bridgeheads for intersite replication
# Site -> LAN
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
# global catalog servers have universal group memberships
# NTDS site settings tell which server is the ISTG and has the option of switching on Universal Group Membership Caching and choosing which GC to obtain the information from
# cross reference objects store the location of each directory partition
# intra-site replication must happen using synchronous high-speed RPC over IP
# inter-site Replication over asynchronous low-speed SMTP is supported for *ONLY* domain controllers of different domains. This means that *ONLY* schema, configuration and global gatalog can be replicated inter-site using SMTP transport.
# DCs of the same domain must replicate using RPC over IP. this means, that domains can span sites *ONLY* when RPC over IP is available.
# synchronous connections are for fast & available connections while asynchronous connections are for slow intermittent connections.
# the replication queue is formed of sync requests which are [partition to be synced + source DC]. each request is processed until complete, gets an error or pre-empted by a higher priority operation.