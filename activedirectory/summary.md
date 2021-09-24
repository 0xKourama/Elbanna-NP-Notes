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